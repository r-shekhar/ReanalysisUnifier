#!/usr/bin/env python

import pymongo
MongoClient = pymongo.MongoClient
from pprint import pprint
import itertools
import functools
import multiprocessing
from pprint import pprint

import numpy as np
import pandas as pd
import netCDF4
import sys
import datetime

def year_month_iter(start_year, start_month, end_year, end_month ):
    ym_start= 12*start_year + start_month - 1
    ym_end= 12*end_year + end_month - 1
    for ym in range( ym_start, ym_end ):
        y, m = divmod( ym, 12 )
        yield datetime.datetime(y, m+1, 1)


def joblist_create(col, name_regex, varNames):
    print("Querying database for {0} {1}".format(name_regex, ' '.join(varNames)))
    q = {}
    q['filename_on_disk'] = {"$regex": name_regex}

    VarNames = [x.replace('.', '|') for x in varNames]

    q['varnames'] = {"$in": VarNames}

    filenames = []
    datetimes = []
    indices = []
    variables = []
    # pprint.pprint(col.find_one())
    i = 0
    for j in col.find(q):
        # print(j['filename_on_disk'])
        # pprint(j)

        n = len(j['filetime'])
        filenames.extend([j['filename_on_disk'], ]*n)
        datetimes.extend(j['filetime'])
        indices.extend(list(range(n)))

        #assuming more than one variable from varNames isn't in a file
        for v,v2 in zip(varNames,VarNames):
            # print(j['variables'].keys())
            # print(v)
            if v2 in j['variables']:
                # print(v)
                variables.extend([v]*n)
        i += 1

    d = {'filenames': filenames, 'datetimes': datetimes, 'indices': indices,
         'variables': variables}

    # pprint(d)
    df = pd.DataFrame(d)
    df = df.sort_values(by='datetimes')

    # renumber row index
    df.reset_index()
    df.index = range(len(datetimes))

    # diagnostics
    # dt = np.array(df.datetimes, dtype='M8[h]')
    # d2 = dt[1:] - dt[:-1]
    # print(d2)

    return df


def create_output_file(reanalysis, timeres,
                       field, field_units, field_long_name,
                       level, latitude, longitude, noclobber=True,
                       compress=True):
    filename = 'reanalysis_clean/{0}.{1}.{2}.nc'.format(reanalysis, timeres,
                                                        field)
    out_fh = netCDF4.Dataset(filename, 'w',
                             format='NETCDF4',
                             noclobber=noclobber)
    out_fh.Conventions = 'CF-1.5'
    out_fh.Dataset = reanalysis
    out_fh.TimeResolution = timeres
    out_fh.createDimension("time", None)

    out_fh.createDimension("latitude", len(latitude))
    out_fh.createDimension("longitude", len(longitude))

    coord_tuple = ("time", "latitude", "longitude")
    if not (level is None):
        out_fh.createDimension("level", len(level))
        level_coord = out_fh.createVariable("level", 'f4', ('level',),
                                            zlib=True, complevel=1)
        level_coord.units = 'hPa'
        level_coord.axis = 'Z'
        if np.max(level) > 2000.:
            level_coord[:] = level / 100.
        else:
            level_coord[:] = level
        coord_tuple = ("time", "level", "latitude", "longitude")

    time = out_fh.createVariable('time', 'f4', ('time',),
                                 zlib=True, complevel=1)
    time.units = "hours since 1970-1-1"
    time.standard_name = 'time'
    time.axis = 'T'

    lat = out_fh.createVariable('latitude', 'f4', ('latitude',),
                                zlib=True, complevel=1)
    lat.standard_name = "latitude"
    lat.units = 'degrees_north'
    lat.actual_range = (-90., 90.)
    lat.axis = 'Y'
    lat[:] = latitude

    lon = out_fh.createVariable("longitude", 'f4', ('longitude',),
                                zlib=True, complevel=1)
    lon.standard_name = "longitude"
    lon.units = 'degrees_east'
    lon.actual_range = (0., 360.)
    lon.axis = 'X'
    lon[:] = longitude

    data = out_fh.createVariable(field, 'f4', coord_tuple,
                                 zlib=True, complevel=1)
    data.long_name = field_long_name
    data.units = field_units

    return out_fh


def glue_joblist_into_data(joblist, reanalysis, timeres,
                           field, field_units, field_long_name):
    imap = itertools.imap
    # print(joblist)

    print("Building dataset for {0} {1} {2}".format(
        reanalysis, timeres, field))

    data_file_initialized = False

    m = imap(fetch_data, joblist.itertuples())
    for k in m:
        new_index, new_timestamp, data, coord_arrays = k
        if not data_file_initialized:
            if len(coord_arrays) == 2:
                lat, lon = coord_arrays
                fh = create_output_file(reanalysis, timeres,
                                        field, field_units, field_long_name,
                                        None, *coord_arrays)
            elif len(coord_arrays) == 3:
                lev, lat, lon = coord_arrays
                fh = create_output_file(reanalysis, timeres,
                                        field, field_units, field_long_name,
                                        *coord_arrays)
            else:
                print("Don't understand coordinate system.")
                print(coord_arrays)
                sys.exit(8)
            data_file_initialized = True

        new_datetime = new_timestamp.to_datetime()
        fh.variables['time'][new_index] = netCDF4.date2num(
            new_datetime, units=fh.variables['time'].units)
        fh.variables[field][new_index] = data
        del data
        import gc
        gc.collect()

    fh.close()
    print("Dataset build complete for {0} {1} {2}".format(
        reanalysis, timeres, field))


def glue_joblist_into_monthly_data(joblist, reanalysis, timeres,
                           field, field_units, field_long_name,
                           deaccumulate=None):
    # could use multiprocessing easily, but seems to cause memory issues
    # better off not using it. Parallelize by extracting multiple variables
    # in separate python processes
    imap = itertools.imap
    # print(joblist)

    print("Building dataset for {0} {1} {2}".format(
        reanalysis, timeres, field))

    dts = np.array(joblist.datetimes, dtype=np.datetime64)
    
    if (dts.shape[0] == 0):
        print("No files matched specified pattern. Are you sure the files are available and the specified pattern is correct?")

    start_datetime = pd.to_datetime(dts[0])
    end_datetime = pd.to_datetime(dts[-1])

    if end_datetime.month == 12:
        ymi = list(year_month_iter(start_datetime.year, start_datetime.month,
                          end_datetime.year+1, 2))
    elif end_datetime.month == 11:
        ymi = list(year_month_iter(start_datetime.year, start_datetime.month,
                          end_datetime.year+1, 1))
    else:
        ymi = list(year_month_iter(start_datetime.year, start_datetime.month,
                          end_datetime.year, end_datetime.month+2))

    data_file_initialized = False
    adjusted_units = "m" if (field_units == 'm2 s-2') else field_units

    for i in range(len(ymi)-1):
        print(ymi[i])
        month_start_date = pd.Timestamp(ymi[i])
        month_end_date = pd.Timestamp(ymi[i+1])

        joblist_month_subset = joblist[joblist.datetimes >= month_start_date]
        joblist_month_subset = joblist_month_subset[
            joblist.datetimes < month_end_date]

        N_timesteps = joblist_month_subset.shape[0]

        m = imap(fetch_data, joblist_month_subset.itertuples())

        k = m.next()
        (junk_index, junk_timestamp, data, coord_arrays) = k
        if not data_file_initialized:
            if len(coord_arrays) == 2:
                lat, lon = coord_arrays
                fh = create_output_file(reanalysis, timeres,
                                        field, adjusted_units, field_long_name,
                                        None, *coord_arrays)
            elif len(coord_arrays) == 3:
                lev, lat, lon = coord_arrays
                fh = create_output_file(reanalysis, timeres,
                                        field, adjusted_units, field_long_name,
                                        *coord_arrays)
            else:
                print("Don't understand coordinate system.")
                print(coord_arrays)
                sys.exit(8)
            data_file_initialized = True
        if (N_timesteps > 1 and (deaccumulate != "ERAI")):
            print("Averaging over {0} timesteps".format(N_timesteps))
            data_sum = np.array(data.copy(), dtype=np.float64)
            for k in m:
                (junk_index, junk_timestamp, data, junk_coords) = k
                data_sum += data
            data_sum /= N_timesteps
            data = data_sum.astype(np.float32)
        elif (N_timesteps > 1 and (deaccumulate == "ERAI")):
            print("Using ERA-Interim deaccumulation")
            new_shape = [N_timesteps,]
            new_shape.extend(data.shape)
            data_arr = np.zeros(tuple(new_shape), dtype=np.float32)

            #restart the iterator
            m = imap(fetch_data, joblist_month_subset.itertuples())

            # fill the array
            for jtimestep, k in enumerate(m):
                (junk_index, junk_timestamp, data, junk_coords) = k
                data_arr[jtimestep] = data / (3.*3600.) # 3 hour accumulation

            #sanity check to make sure we're deaccumulating a whole day
            assert(N_timesteps % 8 == 0)

            # ERAI accumulates over every 12 hours at 3 hour intervals
            # if jtimestep%4 = 0, do nothing, else subtract the previous entry.
            # loop backwards to avoid modifying values before we've deaccumulated
            for jtimestep in reversed(range(0, N_timesteps)):
                # print((jtimestep, np.mean(data_arr[jtimestep])))
                if (jtimestep%4 != 0):
                    data_arr[jtimestep] = data_arr[jtimestep] - data_arr[jtimestep-1]
            # Take time mean of deaccumulated data, pass it for writing
            data = np.mean(data_arr, axis=0)
        else:
            print("Taking data")

        fh.variables['time'][i] = netCDF4.date2num( ymi[i],
            units=fh.variables['time'].units)
        if field_units == 'm2 s-2':
            data /= 9.81

        fh.variables[field][i] = data

    fh.close()
    print("Dataset build complete for {0} {1} {2}".format(
        reanalysis, timeres, field))


def fetch_data(t):
    new_index, dt, fn, old_index, varname = t
    fh = netCDF4.Dataset(fn, 'r')
    d = fh.variables[varname][old_index]
    dcoords = []
    for z in fh.variables[varname].dimensions[1:]:
        if (fh.variables[z].units == "hPa"):
            dcoords.append(fh.variables[z][:]*100.)
        else:
            dcoords.append(fh.variables[z][:])

    fh.close()

    return ((new_index, dt, d, dcoords))


def main():
    client = MongoClient()
    db = client.rawdata
    col = db.netcdf

    deaccumulate_ERAI_forecast = "ERAI"

    dispatch_table = [

        #--------------------- CFSR ----------------------------------------------------------------
        (joblist_create, "^cfsr.monthly", ["SHTFL_L1_Avg_1",], ('cfsr', 'monthly', 'SHF', 'W m-2', "Sensible Heat Flux"),),
        (joblist_create, "^cfsr.monthly", ["LHTFL_L1_Avg_1",], ('cfsr', 'monthly', 'LHF', 'W m-2', "Latent Heat Flux"),),
        (joblist_create, "^cfsr.monthly", ["CSDLF_L1_Avg_1",], ('cfsr', 'monthly', 'SLWDN_CLRSKY', 'W m-2', "Longwave Down at Surface, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["CSDSF_L1_Avg_1",], ('cfsr', 'monthly', 'SSWDN_CLRSKY', 'W m-2', "Shortwave Down at Surface, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["CSULF_L1_Avg_1",], ('cfsr', 'monthly', 'SLWUP_CLRSKY', 'W m-2', "Longwave Up at Surface, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["CSUSF_L1_Avg_1",], ('cfsr', 'monthly', 'SSWUP_CLRSKY', 'W m-2', "Shortwave Up at Surface, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["CSULF_L8_Avg_1",], ('cfsr', 'monthly', 'TLWUP_CLRSKY', 'W m-2', "Longwave Up at TOA, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["CSUSF_L8_Avg_1",], ('cfsr', 'monthly', 'TSWUP_CLRSKY', 'W m-2', "Shortwave Up at TOA, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["DSWRF_L8_Avg_1",], ('cfsr', 'monthly', 'TSWDN', 'W m-2', "Shortwave Down at TOA"),),
        (joblist_create, "^cfsr.monthly", ["USWRF_L8_Avg_1",], ('cfsr', 'monthly', 'TSWUP', 'W m-2', "Shortwave Up at TOA"),),
        (joblist_create, "^cfsr.monthly", ["ULWRF_L8_Avg_1",], ('cfsr', 'monthly', 'TLWUP', 'W m-2', "Longwave Up at TOA"),),
        (joblist_create, "^cfsr.monthly", ["DLWRF_L1_Avg_1",], ('cfsr', 'monthly', 'SLWDN', 'W m-2', "Longwave Down at Surface"),),
        (joblist_create, "^cfsr.monthly", ["ULWRF_L1_Avg_1",], ('cfsr', 'monthly', 'SLWUP', 'W m-2', "Longwave Up at Surface"),),
        (joblist_create, "^cfsr.monthly", ["DSWRF_L1_Avg_1",], ('cfsr', 'monthly', 'SSWDN', 'W m-2', "Shortwave Down at Surface"),),
        (joblist_create, "^cfsr.monthly", ["USWRF_L1_Avg_1",], ('cfsr', 'monthly', 'SSWUP', 'W m-2', "Shortwave Up at Surface"),),
        (joblist_create, "^cfsr.monthly", ["GFLUX_L1_Avg_1",], ('cfsr', 'monthly', 'GHF', 'W m-2', "Ground Heat Flux"),),

        (joblist_create, "^cfsr.monthly", ["HGT_L100_Avg", "HGT_L100"], ('cfsr', 'monthly', 'GHT', "m", "Geopotential Height")),
        (joblist_create, "^cfsr.monthly", ["HGT_L1_Avg", "HGT_L1"], ('cfsr', 'monthly', 'GHT_SURF', "m", "Geopotential Height At Surface")),
        (joblist_create, "^cfsr.monthly", ["PRES_L1_Avg", "PRES_L1"], ('cfsr', 'monthly', 'PSFC', "Pa", "Surface Pressure")),
        (joblist_create, "^cfsr.monthly", ["PRMSL_L101_Avg", "PRMSL_L101"], ('cfsr', 'monthly', 'MSLP', "Pa", "Pressure at Mean Sea Level")),
        (joblist_create, "^cfsr.monthly", ["SPF_H_L100_Avg", "SPF_H_L100"], ('cfsr', 'monthly', 'SPHUM', "kg kg-1", "Specific Humidity")),
        (joblist_create, "^cfsr.monthly", ["TMP_L100_Avg", "TMP_L100"], ('cfsr', 'monthly', 'T', "K", "Air Temperature")),
        (joblist_create, "^cfsr.monthly", ["U_GRD_L100_Avg", "U_GRD_L100"], ('cfsr', 'monthly', 'U', "m s-1", "Zonal Wind")),
        (joblist_create, "^cfsr.monthly", ["V_GRD_L100_Avg", "V_GRD_L100"], ('cfsr', 'monthly', 'V', "m s-1", "Meridional Wind")),
        (joblist_create, "^cfsr.monthly", ["V_VEL_L100_Avg", "V_VEL_L100"], ('cfsr', 'monthly', 'OMEGA', "Pa s-1", "Pressure Velocity")),

        #--------------------- Precip --------------------------------------------------------------

        (joblist_create, "^cmap.monthly", ["precip"], ('cmap', 'monthly', 'PRECIP', "mm day-1", "Precipitation")),
        (joblist_create, "^gpcc.monthly.*combined.*", ["precip"], ('gpcc', 'monthly', 'PRECIP', "mm", "Precipitation")),
        (joblist_create, "^gpcp.monthly.*", ["precip"], ('gpcp', 'monthly', 'PRECIP', "mm day-1", "Precipitation")),

        #--------------------- MERRA ---------------------------------------------------------------

        (joblist_create, "^merra.monthly", ["h"], ('merra', 'monthly', 'GHT', "m", "Geopotential Height")),
        (joblist_create, "^merra.monthly", ["phis"], ('merra', 'monthly', 'GHT_SURF', "m-2 s-2", "Geopotential Height At Surface")),
        (joblist_create, "^merra.monthly", ["ps"], ('merra', 'monthly', 'PSFC', "Pa", "Surface Pressure")),
        (joblist_create, "^merra.monthly", ["slp"], ('merra', 'monthly', 'MSLP', "Pa", "Pressure at Mean Sea Level")),
        (joblist_create, "^merra.monthly", ["qv"], ('merra', 'monthly', 'SPHUM', "kg kg-1", "Specific Humidity")),
        (joblist_create, "^merra.monthly", ["t"], ('merra', 'monthly', 'T', "K", "Air Temperature")),
        (joblist_create, "^merra.monthly", ["u"], ('merra', 'monthly', 'U', "m s-1", "Zonal Wind")),
        (joblist_create, "^merra.monthly", ["v"], ('merra', 'monthly', 'V', "m s-1", "Meridional Wind")),
        (joblist_create, "^merra.monthly", ["omega"], ('merra', 'monthly', 'OMEGA', "Pa s-1", "Pressure Velocity")),

        (joblist_create, "^merra.monthly", ["hflux",], ('merra', 'monthly', 'SHF', 'W m-2', "Sensible Heat Flux"),),
        (joblist_create, "^merra.monthly", ["eflux",], ('merra', 'monthly', 'LHF', 'W m-2', "Latent Heat Flux"),),

        (joblist_create, "^merra.monthly", ["lwgabclr",], ('merra', 'monthly', 'SLWAB_CLRSKY', 'W m-2', "Longwave Absorbed at Surface, Clear Sky"),),
        (joblist_create, "^merra.monthly", ["lwgntclr",], ('merra', 'monthly', 'SLWNT_CLRSKY', 'W m-2', "Longwave Net at Surface, Clear Sky"),),
        (joblist_create, "^merra.monthly", ["lwtupclr",], ('merra', 'monthly', 'TLWUP_CLRSKY', 'W m-2', "Longwave Up at TOA, Clear Sky"),),
        (joblist_create, "^merra.monthly", ["swgdnclr",], ('merra', 'monthly', 'SSWDN_CLRSKY', 'W m-2', "Shortwave Down at Surface, Clear Sky"),),
        (joblist_create, "^merra.monthly", ["swgntclr",], ('merra', 'monthly', 'SSWNT_CLRSKY', 'W m-2', "Shortwave Net at Surface, Clear Sky"),),
        (joblist_create, "^merra.monthly", ["swtntclr",], ('merra', 'monthly', 'TSWNT_CLRSKY', 'W m-2', "Shortwave Net at TOA, Clear Sky"),),

        (joblist_create, "^merra.monthly", ["lwgab",], ('merra', 'monthly', 'SLWAB', 'W m-2', "Longwave Absorbed at Surface"),),
        (joblist_create, "^merra.monthly", ["lwgem",], ('merra', 'monthly', 'SLWEM', 'W m-2', "Longwave Emitted at Surface"),),
        (joblist_create, "^merra.monthly", ["lwgnt",], ('merra', 'monthly', 'SLWNT', 'W m-2', "Longwave Net at Surface"),),
        (joblist_create, "^merra.monthly", ["lwtup",], ('merra', 'monthly', 'TLWUP', 'W m-2', "Longwave Up at TOA"),),
        (joblist_create, "^merra.monthly", ["swgdn",], ('merra', 'monthly', 'SSWDN', 'W m-2', "Shortwave Down at Surface"),),
        (joblist_create, "^merra.monthly", ["swgnt",], ('merra', 'monthly', 'SSWNT', 'W m-2', "Shortwave Net at Surface"),),
        (joblist_create, "^merra.monthly", ["swtdn",], ('merra', 'monthly', 'TSWDN', 'W m-2', "Shortwave Down at TOA"),),
        (joblist_create, "^merra.monthly", ["swtnt",], ('merra', 'monthly', 'TSWNT', 'W m-2', "Shortwave Net at TOA"),),

        #--------------------- MERRA 2 -------------------------------------------------------------

        (joblist_create, "^merra2.monthly", ["H"], ('merra2', 'monthly', 'GHT', "m", "Geopotential Height")),
        (joblist_create, "^merra2.monthly", ["PHIS"], ('merra2', 'monthly', 'GHT_SURF', "m-2 s-2", "Geopotential Height At Surface")),
        (joblist_create, "^merra2.monthly", ["PS"], ('merra2', 'monthly', 'PSFC', "Pa", "Surface Pressure")),
        (joblist_create, "^merra2.monthly", ["SLP"], ('merra2', 'monthly', 'MSLP', "Pa", "Pressure at Mean Sea Level")),
        (joblist_create, "^merra2.monthly", ["QV"], ('merra2', 'monthly', 'SPHUM', "kg kg-1", "Specific Humidity")),
        (joblist_create, "^merra2.monthly", ["T"], ('merra2', 'monthly', 'T', "K", "Air Temperature")),
        (joblist_create, "^merra2.monthly", ["U"], ('merra2', 'monthly', 'U', "m s-1", "Zonal Wind")),
        (joblist_create, "^merra2.monthly", ["V"], ('merra2', 'monthly', 'V', "m s-1", "Meridional Wind")),
        (joblist_create, "^merra2.monthly", ["OMEGA"], ('merra2', 'monthly', 'OMEGA', "Pa s-1", "Pressure Velocity")),

        (joblist_create, "^merra2.monthly", ["HFLUX",], ('merra2', 'monthly', 'SHF', 'W m-2', "Sensible Heat Flux"),),
        (joblist_create, "^merra2.monthly", ["EFLUX",], ('merra2', 'monthly', 'LHF', 'W m-2', "Latent Heat Flux"),),
        (joblist_create, "^merra2.monthly", ["LWGABCLR",], ('merra2', 'monthly', 'SLWAB_CLRSKY', 'W m-2', "Longwave Absorbed at Surface, Clear Sky"),),
        (joblist_create, "^merra2.monthly", ["LWGNTCLR",], ('merra2', 'monthly', 'SLWNT_CLRSKY', 'W m-2', "Longwave Net at Surface, Clear Sky"),),
        (joblist_create, "^merra2.monthly", ["LWTUPCLR",], ('merra2', 'monthly', 'TLWUP_CLRSKY', 'W m-2', "Longwave Up at TOA, Clear Sky"),),
        (joblist_create, "^merra2.monthly", ["SWGDNCLR",], ('merra2', 'monthly', 'SSWDN_CLRSKY', 'W m-2', "Shortwave Down at Surface, Clear Sky"),),
        (joblist_create, "^merra2.monthly", ["SWGNTCLR",], ('merra2', 'monthly', 'SSWNT_CLRSKY', 'W m-2', "Shortwave Net at Surface, Clear Sky"),),
        (joblist_create, "^merra2.monthly", ["SWTNTCLR",], ('merra2', 'monthly', 'TSWNT_CLRSKY', 'W m-2', "Shortwave Net at TOA, Clear Sky"),),

        (joblist_create, "^merra2.monthly", ["LWGAB",], ('merra2', 'monthly', 'SLWAB', 'W m-2', "Longwave Absorbed at Surface"),),
        (joblist_create, "^merra2.monthly", ["LWGEM",], ('merra2', 'monthly', 'SLWEM', 'W m-2', "Longwave Emitted at Surface"),),
        (joblist_create, "^merra2.monthly", ["LWGNT",], ('merra2', 'monthly', 'SLWNT', 'W m-2', "Longwave Net at Surface"),),
        (joblist_create, "^merra2.monthly", ["LWTUP",], ('merra2', 'monthly', 'TLWUP', 'W m-2', "Longwave Up at TOA"),),
        (joblist_create, "^merra2.monthly", ["SWGDN",], ('merra2', 'monthly', 'SSWDN', 'W m-2', "Shortwave Down at Surface"),),
        (joblist_create, "^merra2.monthly", ["SWGNT",], ('merra2', 'monthly', 'SSWNT', 'W m-2', "Shortwave Net at Surface"),),
        (joblist_create, "^merra2.monthly", ["SWTDN",], ('merra2', 'monthly', 'TSWDN', 'W m-2', "Shortwave Down at TOA"),),
        (joblist_create, "^merra2.monthly", ["SWTNT",], ('merra2', 'monthly', 'TSWNT', 'W m-2', "Shortwave Net at TOA"),),

        #--------------------- ERA Interim ---------------------------------------------------------

        (joblist_create, "^eraI.monthly", ["z"], ('erai', 'monthly', 'GHT', "m2 s-2", "Geopotential Height")),
        # (joblist_create, "^eraI.monthly", ["PHIS"], ('eraI', 'monthly', 'GHT_SURF', "m-2 s-2", "Geopotential Height At Surface")),
        (joblist_create, "^eraI.monthly", ["sp"], ('erai', 'monthly', 'PSFC', "Pa", "Surface Pressure")),
        (joblist_create, "^eraI.monthly", ["msl"], ('erai', 'monthly', 'MSLP', "Pa", "Pressure at Mean Sea Level")),
        (joblist_create, "^eraI.monthly", ["q"], ('erai', 'monthly', 'SPHUM', "kg kg-1", "Specific Humidity")),
        (joblist_create, "^eraI.monthly", ["t"], ('erai', 'monthly', 'T', "K", "Air Temperature")),
        (joblist_create, "^eraI.monthly", ["u"], ('erai', 'monthly', 'U', "m s-1", "Zonal Wind")),
        (joblist_create, "^eraI.monthly", ["v"], ('erai', 'monthly', 'V', "m s-1", "Meridional Wind")),
        (joblist_create, "^eraI.monthly", ["w"], ('erai', 'monthly', 'OMEGA', "Pa s-1", "Pressure Velocity")),

        (joblist_create, "^eraI.monthly", ["vo"], ('erai', 'monthly', 'MODEL_VORTICITY', "s-1", "Relative Vorticity")),
        (joblist_create, "^eraI.monthly", ["d"], ('erai', 'monthly', 'MODEL_DIVERGENCE', "s-1", "Divergence")),

        (joblist_create, "^eraI.monthly", ["p65.162"], ('erai', 'monthly', 'EASTWARD_MASS_FLUX', "kg m-1 s-1", "Vertical Integral of Eastward Mass Flux")),
        (joblist_create, "^eraI.monthly", ["p66.162"], ('erai', 'monthly', 'NORTHWARD_MASS_FLUX', "kg m-1 s-1", "Vertical Integral of Northward Mass Flux")),
        (joblist_create, "^eraI.monthly", ["p69.162"], ('erai', 'monthly', 'EASTWARD_HEAT_FLUX', "W m-1", "Vertical Integral of Eastward Mass Flux")),
        (joblist_create, "^eraI.monthly", ["p70.162"], ('erai', 'monthly', 'NORTHWARD_HEAT_FLUX', "W m-1", "Vertical Integral of Northward Mass Flux")),
        (joblist_create, "^eraI.monthly", ["p71.162"], ('erai', 'monthly', 'EASTWARD_WATERVAPOR_FLUX', "kg m-1 s-1", "Vertical Integral of Eastward Water Vapor Flux")),
        (joblist_create, "^eraI.monthly", ["p72.162"], ('erai', 'monthly', 'NORTHWARD_WATERVAPOR_FLUX', "kg m-1 s-1", "Vertical Integral of Northward Water Vapor Flux")),
        (joblist_create, "^eraI.monthly", ["p73.162"], ('erai', 'monthly', 'EASTWARD_GHT_FLUX', "W m-1", "Vertical Integral of Eastward Geopotential Flux")),
        (joblist_create, "^eraI.monthly", ["p74.162"], ('erai', 'monthly', 'NORTHWARD_GHT_FLUX', "W m-1", "Vertical Integral of Northward Geopotential Flux")),

        (joblist_create, "^eraI.monthly", ["p81.162"], ('erai', 'monthly', 'DIV_MASS_FLUX', "kg m-2 s-1", "Vertical Integral of Divergence of Mass Flux")),
        (joblist_create, "^eraI.monthly", ["p83.162"], ('erai', 'monthly', 'DIV_HEAT_FLUX', "W m-2", "Vertical Integral of Divergence of Heat Flux")),
        (joblist_create, "^eraI.monthly", ["p84.162"], ('erai', 'monthly', 'DIV_WATERVAPOR_FLUX', "kg m-2 s-1", "Vertical Integral of Divergence of Water Vapor Flux")),
        (joblist_create, "^eraI.monthly", ["p85.162"], ('erai', 'monthly', 'DIV_GHT_FLUX', "W m-2", "Vertical Integral of Divergence of Geopotential Flux")),

        (joblist_create, "^eraI.monthly", ["sshf",], ('erai', 'monthly', 'SHF', 'W m-2', "Sensible Heat Flux", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["slhf",], ('erai', 'monthly', 'LHF', 'W m-2', "Latent Heat Flux", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["ssrd",], ('erai', 'monthly', 'SSWDN', 'W m-2', "Shortwave Down at Surface", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["strd",], ('erai', 'monthly', 'SLWDN', 'W m-2', "Longwave Down at Surface", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["ssr",], ('erai', 'monthly', 'SSWNT', 'W m-2', "Shortwave Net at Surface", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["str",], ('erai', 'monthly', 'SLWNT', 'W m-2', "Longwave Net at Surface", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["tisr",], ('erai', 'monthly', 'TSWDN', 'W m-2', "Shortwave Down at TOA", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["tsr",], ('erai', 'monthly', 'TSWNT', 'W m-2', "Shortwave Net at TOA", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["ttr",], ('erai', 'monthly', 'TLWNT', 'W m-2', "Longwave Net at TOA", deaccumulate_ERAI_forecast),),

        (joblist_create, "^eraI.monthly", ["strc",], ('erai', 'monthly', 'SLWNT_CLRSKY', 'W m-2', "Longwave Net at Surface, Clear Sky", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["ssrc",], ('erai', 'monthly', 'SSWNT_CLRSKY', 'W m-2', "Shortwave Net at Surface, Clear Sky", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["ttrc",], ('erai', 'monthly', 'TLWNT_CLRSKY', 'W m-2', "Longwave Net at TOA, Clear Sky", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["tsrc",], ('erai', 'monthly', 'TSWNT_CLRSKY', 'W m-2', "Shortwave Net at TOA, Clear Sky", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["tsrc",], ('erai', 'monthly', 'TSWNT_CLRSKY', 'W m-2', "Shortwave Net at TOA, Clear Sky", deaccumulate_ERAI_forecast),),

        (joblist_create, "^eraI.monthly", ["tp",], ('erai', 'monthly', 'PRECIP', 'm', "Precipitation. meters per 3 hours.", deaccumulate_ERAI_forecast),),
        (joblist_create, "^eraI.monthly", ["e",], ('erai', 'monthly', 'EVAP', 'm', "Evaporation. meters per 3 hours.", deaccumulate_ERAI_forecast),),

        (joblist_create, "^ersst.monthly", ["sst",], ('ersst', 'monthly', 'SST', 'K', "Sea Surface Temperature"),),
        
        #--------------------- CMIP5 runs ---------------------------------------------------------

        # joblist_create     #regex matching files with this var       #var name in files   # new prefix               #timefreq   #new name    #units        # new description
        (joblist_create, "^cmip5.hfls.Amon.GFDL.ESM2G.historical.r1i1p1",  ["hfls",],  ('cmip5.gfdl.esm2g.historical', 'monthly', 'LHF',        'W m-2',      "Latent Heat Flux"),),
        (joblist_create, "^cmip5.hfss.Amon.GFDL.ESM2G.historical.r1i1p1",  ["hfss",],  ('cmip5.gfdl.esm2g.historical', 'monthly', 'SHF',        'W m-2',      "Sensible Heat Flux"),),
        (joblist_create, "^cmip5.hurs.Amon.GFDL.ESM2G.historical.r1i1p1",  ["hurs",],  ('cmip5.gfdl.esm2g.historical', 'monthly', 'RH_SURF',    '%',          "Near Surface Relative Humidity"),),
        (joblist_create, "^cmip5.hus.Amon.GFDL.ESM2G.historical.r1i1p1",   ["hus",],   ('cmip5.gfdl.esm2g.historical', 'monthly', 'SPHUM',      'kg kg-1',    "Specific Humidity"),),
        (joblist_create, "^cmip5.huss.Amon.GFDL.ESM2G.historical.r1i1p1",  ["huss",],  ('cmip5.gfdl.esm2g.historical', 'monthly', 'SPHUM_SURF', 'kg kg-1',    "Near Surface Specific Humidity"),),
        (joblist_create, "^cmip5.mrsos.Lmon.GFDL.ESM2G.historical.r1i1p1", ["mrsos",], ('cmip5.gfdl.esm2g.historical', 'monthly', 'SOILMOIST',  'kg m-2',     "Soil Moisture in Upper Soil Column"),),
        (joblist_create, "^cmip5.pr.Amon.GFDL.ESM2G.historical.r1i1p1",    ["pr",],    ('cmip5.gfdl.esm2g.historical', 'monthly', 'PRECIP',     'kg m-2 s-1', "Precipitation"),),
        (joblist_create, "^cmip5.ps.Amon.GFDL.ESM2G.historical.r1i1p1",    ["ps",],    ('cmip5.gfdl.esm2g.historical', 'monthly', 'PSFC',       'Pa',         "Surface Pressure"),),
        (joblist_create, "^cmip5.rlds.Amon.GFDL.ESM2G.historical.r1i1p1",  ["rlds",],  ('cmip5.gfdl.esm2g.historical', 'monthly', 'SLWDN',      'W m-2',      "Longwave Down at Surface"),),
        (joblist_create, "^cmip5.rlus.Amon.GFDL.ESM2G.historical.r1i1p1",  ["rlus",],  ('cmip5.gfdl.esm2g.historical', 'monthly', 'SLWUP',      'W m-2',      "Longwave Up at Surface"),),
        (joblist_create, "^cmip5.ta.Amon.GFDL.ESM2G.historical.r1i1p1",    ["ta",],    ('cmip5.gfdl.esm2g.historical', 'monthly', 'T',          'K',          "Air Temperature"),),
        (joblist_create, "^cmip5.tas.Amon.GFDL.ESM2G.historical.r1i1p1",   ["tas",],   ('cmip5.gfdl.esm2g.historical', 'monthly', 'T_SURF',     'K',          "Near Surface Air Temperature"),),
        (joblist_create, "^cmip5.ua.Amon.GFDL.ESM2G.historical.r1i1p1",    ["ua",],    ('cmip5.gfdl.esm2g.historical', 'monthly', 'U',          'm s-1',      "Zonal Wind"),),
        (joblist_create, "^cmip5.va.Amon.GFDL.ESM2G.historical.r1i1p1",    ["va",],    ('cmip5.gfdl.esm2g.historical', 'monthly', 'V',          'm s-1',      "Meridional Wind"),),
        (joblist_create, "^cmip5.wap.Amon.GFDL.ESM2G.historical.r1i1p1",   ["wap",],   ('cmip5.gfdl.esm2g.historical', 'monthly', 'OMEGA',      'Pa s-1',     "Pressure Velocity"),),
        (joblist_create, "^cmip5.zg.Amon.GFDL.ESM2G.historical.r1i1p1",    ["zg",],    ('cmip5.gfdl.esm2g.historical', 'monthly', 'GHT',        'm',          "Geopotential Height"),),
                  
    ]

    try:
        choice = int(sys.argv[1])
        assert(choice >=0 and choice < len(dispatch_table))
    except:
        print(("Did not understand specified argument. "
            " Require a number between 0-{0}".format(len(dispatch_table)-1)) )
        pprint(list(enumerate(dispatch_table)))
        sys.exit(8)

    k = dispatch_table[choice]
    f = k[0]
    jl = f(col, k[1], k[2])
    glue_joblist_into_monthly_data(jl, *k[3])

    client.close()


if __name__ == '__main__':
    main()
