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


# def joblist_cfsr_flatvar(col, varName):
#     print("Querying database for CFSR {0}".format(varName))
#     q = {}
#     q['filename_on_disk'] = {"$regex": "^cfsr.monthly.*"}
#     q['varnames'] = {"$in": [varName]}

#     filenames = []
#     datetimes = []
#     indices = []
#     variables = []
#     # pprint.pprint(col.find_one())
#     i = 0
#     for j in col.find(q):
#         # print(j['filename_on_disk'])
#         # pprint(j)

#         n = len(j['filetime'])
#         filenames.extend([j['filename_on_disk'], ]*n)
#         datetimes.extend(j['filetime'])
#         indices.extend(list(range(n)))
#         variables.extend([varName]*n)
#         i += 1
#     # print(i)

#     d = {'filenames': filenames, 'datetimes': datetimes, 'indices': indices,
#          'variables': variables}
#     df = pd.DataFrame(d)
#     df = df.sort_values(by='datetimes')
#     dt = np.array(df.datetimes, dtype='M8[h]')
#     d2 = dt[1:] - dt[:-1]
#     assert(np.all(d2 == np.timedelta64(6, 'h')))
#     return df


def joblist_cfsr_3dvar(col, varNames):
    print("Querying database for CFSR {0}".format(varNames[0]))
    q = {}
    q['filename_on_disk'] = {"$regex": "^cfsr.monthly.*"}
    q['varnames'] = {"$in": varNames}

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
        for v in varNames:
            if v in j['variables']:
                # print(v)
                variables.extend([v]*n)
        i += 1
    # print(i)

    d = {'filenames': filenames, 'datetimes': datetimes, 'indices': indices,
         'variables': variables}
    df = pd.DataFrame(d)
    df = df.sort_values(by='datetimes')

    # renumber row index
    df.reset_index()
    df.index = range(len(datetimes))

    dt = np.array(df.datetimes, dtype='M8[h]')
    d2 = dt[1:] - dt[:-1]

    # for z in df.itertuples():
    #     print(z[1])

    # assert(np.all(d2 == np.timedelta64(6, 'h')))
    return df

def joblist_create(col, name_regex, varNames):
    print("Querying database for CFSR {0}".format(varNames[0]))
    q = {}
    q['filename_on_disk'] = {"$regex": name_regex}
    q['varnames'] = {"$in": varNames}

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
        for v in varNames:
            if v in j['variables']:
                # print(v)
                variables.extend([v]*n)
        i += 1
    # print(i)

    d = {'filenames': filenames, 'datetimes': datetimes, 'indices': indices,
         'variables': variables}
    df = pd.DataFrame(d)
    df = df.sort_values(by='datetimes')

    # renumber row index
    df.reset_index()
    df.index = range(len(datetimes))

    dt = np.array(df.datetimes, dtype='M8[h]')
    d2 = dt[1:] - dt[:-1]

    # for z in df.itertuples():
    #     print(z[1])

    # assert(np.all(d2 == np.timedelta64(6, 'h')))
    return df


def create_output_file(reanalysis, timeres,
                       field, field_units, field_long_name,
                       level, latitude, longitude):
    filename = 'reanalysis_clean/{0}.{1}.{2}.nc'.format(reanalysis, timeres,
                                                        field)
    out_fh = netCDF4.Dataset(filename, 'w',
                             format='NETCDF4',
                             noclobber=True)
    out_fh.Conventions = 'CF-1.0'
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
        level_coord.units = 'Pa'
        level_coord.axis = 'Z'
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
                           field, field_units, field_long_name):
    # could use multiprocessing easily, but seems to cause memory issues
    # better off not using it. Parallelize by extracting multiple variables
    # in separate python processes
    imap = itertools.imap 
    # print(joblist)

    print("Building dataset for {0} {1} {2}".format(
        reanalysis, timeres, field))

    dts = np.array(joblist.datetimes, dtype=np.datetime64)

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
        if (N_timesteps > 1):
            print("Averaging over {0} timesteps".format(N_timesteps))
            data_sum = np.array(data.copy(), dtype=np.float64)
            for k in m:
                (junk_index, junk_timestamp, data, junk_coords) = k
                data_sum += data
            data_sum /= N_timesteps
            data = data_sum.astype(np.float32)
        else:
            print("Taking data")

        fh.variables['time'][i] = netCDF4.date2num( ymi[i],
            units=fh.variables['time'].units)
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


    dispatch_table = [
        (joblist_create, "^cfsr.monthly", ["SHTFL_L1_Avg_1",],('cfsr', 'monthly', 'SHF', 'Wm-2', "Sensible Heat Flux"),),
        (joblist_create, "^cfsr.monthly", ["LHTFL_L1_Avg_1",],('cfsr', 'monthly', 'LHF', 'Wm-2', "Latent Heat Flux"),),
        (joblist_create, "^cfsr.monthly", ["CSDLF_L1_Avg_1",],('cfsr', 'monthly', 'SLWDN_CLRSKY', 'Wm-2', "Longwave Down at Surface, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["CSDSF_L1_Avg_1",],('cfsr', 'monthly', 'SSWDN_CLRSKY', 'Wm-2', "Shortwave Down at Surface, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["CSULF_L1_Avg_1",],('cfsr', 'monthly', 'SLWUP_CLRSKY', 'Wm-2', "Longwave Up at Surface, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["CSUSF_L1_Avg_1",],('cfsr', 'monthly', 'SSWUP_CLRSKY', 'Wm-2', "Shortwave Up at Surface, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["CSULF_L8_Avg_1",],('cfsr', 'monthly', 'TLWUP_CLRSKY', 'Wm-2', "Longwave Up at TOA, Clear Sky"),),
        (joblist_create, "^cfsr.monthly", ["DSWRF_L8_Avg_1",],('cfsr', 'monthly', 'TSWDN', 'Wm-2', "Shortwave Down at TOA"),),
        (joblist_create, "^cfsr.monthly", ["USWRF_L8_Avg_1",],('cfsr', 'monthly', 'TSWUP', 'Wm-2', "Shortwave UP at TOA"),),
        (joblist_create, "^cfsr.monthly", ["ULWRF_L8_Avg_1",],('cfsr', 'monthly', 'TLWUP', 'Wm-2', "Longwave Up at TOA"),),
        (joblist_create, "^cfsr.monthly", ["DLWRF_L1_Avg_1",],('cfsr', 'monthly', 'SLWDN', 'Wm-2', "Longwave Down at Surface"),),
        (joblist_create, "^cfsr.monthly", ["ULWRF_L1_Avg_1",],('cfsr', 'monthly', 'SLWUP', 'Wm-2', "Longwave Up at Surface"),),
        (joblist_create, "^cfsr.monthly", ["DSWRF_L1_Avg_1",],('cfsr', 'monthly', 'SSWDN', 'Wm-2', "Shortwave Down at Surface"),),
        (joblist_create, "^cfsr.monthly", ["USWRF_L1_Avg_1",],('cfsr', 'monthly', 'SSWUP', 'Wm-2', "Shortwave Up at Surface"),),
        (joblist_create, "^cfsr.monthly", ["GFLUX_L1_Avg_1",],('cfsr', 'monthly', 'GHF', 'Wm-2', "Ground Heat Flux"),),

        (joblist_create, "^cfsr.monthly", ["HGT_L100_Avg", "HGT_L100"],('cfsr', 'monthly', 'GHT', "gpm", "Geopotential Height")),
        (joblist_create, "^cfsr.monthly", ["HGT_L1_Avg", "HGT_L1"],('cfsr', 'monthly', 'GHT_SURF', "gpm", "Geopotential Height At Surface")),        
        (joblist_create, "^cfsr.monthly", ["PRES_L1_Avg", "PRES_L1"],('cfsr', 'monthly', 'PSFC', "Pa", "Surface Pressure")),
        (joblist_create, "^cfsr.monthly", ["PRMSL_L101_Avg", "PRMSL_L101"],('cfsr', 'monthly', 'MSLP', "Pa", "Pressure at Mean Sea Level")),
        (joblist_create, "^cfsr.monthly", ["SPF_H_L100_Avg", "SPF_H_L100"],('cfsr', 'monthly', 'SPHUM', "kg kg-1", "Specific Humidity")),
        (joblist_create, "^cfsr.monthly", ["TMP_L100_Avg", "TMP_L100"],('cfsr', 'monthly', 'T', "K", "Air Temperature")),
        (joblist_create, "^cfsr.monthly", ["U_GRD_L100_Avg", "U_GRD_L100"],('cfsr', 'monthly', 'U', "m s-1", "Zonal Wind")),
        (joblist_create, "^cfsr.monthly", ["V_GRD_L100_Avg", "V_GRD_L100"],('cfsr', 'monthly', 'V', "m s-1", "Meridional Wind")),
        (joblist_create, "^cfsr.monthly", ["V_VEL_L100_Avg", "V_VEL_L100"],('cfsr', 'monthly', 'OMEGA', "Pa s-1", "Pressure Velocity")),

        (joblist_create, "^cmap.monthly", ["precip"],('cmap', 'monthly', 'PRECIP', "mm day-1", "Precipitation")),
        (joblist_create, "^gpcc.monthly.*combined.*", ["precip"],('gpcc', 'monthly', 'PRECIP', "mm", "Precipitation")),
        (joblist_create, "^gpcp.monthly.*", ["precip"],('gpcp', 'monthly', 'PRECIP', "mm day-1", "Precipitation")),

        (joblist_create, "^merra.monthly", ["h"],('merra', 'monthly', 'GHT', "gpm", "Geopotential Height")),
        (joblist_create, "^merra.monthly", ["phis"],('merra', 'monthly', 'GHT_SURF', "m-2 s-2", "Geopotential Height At Surface")),        
        (joblist_create, "^merra.monthly", ["ps"],('merra', 'monthly', 'PSFC', "Pa", "Surface Pressure")),
        (joblist_create, "^merra.monthly", ["slp"],('merra', 'monthly', 'MSLP', "Pa", "Pressure at Mean Sea Level")),
        (joblist_create, "^merra.monthly", ["qv"],('merra', 'monthly', 'SPHUM', "kg kg-1", "Specific Humidity")),
        (joblist_create, "^merra.monthly", ["t"],('merra', 'monthly', 'T', "K", "Air Temperature")),
        (joblist_create, "^merra.monthly", ["u"],('merra', 'monthly', 'U', "m s-1", "Zonal Wind")),
        (joblist_create, "^merra.monthly", ["v"],('merra', 'monthly', 'V', "m s-1", "Meridional Wind")),
        (joblist_create, "^merra.monthly", ["omega"],('merra', 'monthly', 'OMEGA', "Pa s-1", "Pressure Velocity")),

        (joblist_create, "^merra.monthly", ["hflux",],('merra', 'monthly', 'SHF', 'Wm-2', "Sensible Heat Flux"),),
        (joblist_create, "^merra.monthly", ["eflux",],('merra', 'monthly', 'LHF', 'Wm-2', "Latent Heat Flux"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SLWDN_CLRSKY', 'Wm-2', "Longwave Down at Surface, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SSWDN_CLRSKY', 'Wm-2', "Shortwave Down at Surface, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SLWUP_CLRSKY', 'Wm-2', "Longwave Up at Surface, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SSWUP_CLRSKY', 'Wm-2', "Shortwave Up at Surface, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'TLWUP_CLRSKY', 'Wm-2', "Longwave Up at TOA, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'TSWDN', 'Wm-2', "Shortwave Down at TOA"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'TSWUP', 'Wm-2', "Shortwave UP at TOA"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'TLWUP', 'Wm-2', "Longwave Up at TOA"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SLWDN', 'Wm-2', "Longwave Down at Surface"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SLWUP', 'Wm-2', "Longwave Up at Surface"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SSWDN', 'Wm-2', "Shortwave Down at Surface"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SSWUP', 'Wm-2', "Shortwave Up at Surface"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'GHF', 'Wm-2', "Ground Heat Flux"),),

        (joblist_create, "^merra2.monthly", ["H"],('merra2', 'monthly', 'GHT', "gpm", "Geopotential Height")),
        (joblist_create, "^merra2.monthly", ["PHIS"],('merra2', 'monthly', 'GHT_SURF', "m-2 s-2", "Geopotential Height At Surface")),        
        (joblist_create, "^merra2.monthly", ["PS"],('merra2', 'monthly', 'PSFC', "Pa", "Surface Pressure")),
        (joblist_create, "^merra2.monthly", ["SLP"],('merra2', 'monthly', 'MSLP', "Pa", "Pressure at Mean Sea Level")),
        (joblist_create, "^merra2.monthly", ["QV"],('merra2', 'monthly', 'SPHUM', "kg kg-1", "Specific Humidity")),
        (joblist_create, "^merra2.monthly", ["T"],('merra2', 'monthly', 'T', "K", "Air Temperature")),
        (joblist_create, "^merra2.monthly", ["U"],('merra2', 'monthly', 'U', "m s-1", "Zonal Wind")),
        (joblist_create, "^merra2.monthly", ["V"],('merra2', 'monthly', 'V', "m s-1", "Meridional Wind")),
        (joblist_create, "^merra2.monthly", ["OMEGA"],('merra2', 'monthly', 'OMEGA', "Pa s-1", "Pressure Velocity")),

        (joblist_create, "^merra2.monthly", ["HFLUX",],('merra2', 'monthly', 'SHF', 'Wm-2', "Sensible Heat Flux"),),
        (joblist_create, "^merra2.monthly", ["EFLUX",],('merra2', 'monthly', 'LHF', 'Wm-2', "Latent Heat Flux"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SLWDN_CLRSKY', 'Wm-2', "Longwave Down at Surface, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SSWDN_CLRSKY', 'Wm-2', "Shortwave Down at Surface, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SLWUP_CLRSKY', 'Wm-2', "Longwave Up at Surface, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SSWUP_CLRSKY', 'Wm-2', "Shortwave Up at Surface, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'TLWUP_CLRSKY', 'Wm-2', "Longwave Up at TOA, Clear Sky"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'TSWDN', 'Wm-2', "Shortwave Down at TOA"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'TSWUP', 'Wm-2', "Shortwave UP at TOA"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'TLWUP', 'Wm-2', "Longwave Up at TOA"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SLWDN', 'Wm-2', "Longwave Down at Surface"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SLWUP', 'Wm-2', "Longwave Up at Surface"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SSWDN', 'Wm-2', "Shortwave Down at Surface"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'SSWUP', 'Wm-2', "Shortwave Up at Surface"),),
        # (joblist_create, "^merra.monthly", ["",],('merra', 'monthly', 'GHF', 'Wm-2', "Ground Heat Flux"),),

        (joblist_create, "^eraI.monthly", ["z"],('eraI', 'monthly', 'GHT', "m-2 s-2", "Geopotential Height")),
        # (joblist_create, "^eraI.monthly", ["PHIS"],('eraI', 'monthly', 'GHT_SURF', "m-2 s-2", "Geopotential Height At Surface")),        
        (joblist_create, "^eraI.monthly", ["sp"],('eraI', 'monthly', 'PSFC', "Pa", "Surface Pressure")),
        (joblist_create, "^eraI.monthly", ["msl"],('eraI', 'monthly', 'MSLP', "Pa", "Pressure at Mean Sea Level")),
        (joblist_create, "^eraI.monthly", ["q"],('eraI', 'monthly', 'SPHUM', "kg kg-1", "Specific Humidity")),
        (joblist_create, "^eraI.monthly", ["t"],('eraI', 'monthly', 'T', "K", "Air Temperature")),
        (joblist_create, "^eraI.monthly", ["u"],('eraI', 'monthly', 'U', "m s-1", "Zonal Wind")),
        (joblist_create, "^eraI.monthly", ["v"],('eraI', 'monthly', 'V', "m s-1", "Meridional Wind")),
        (joblist_create, "^eraI.monthly", ["w"],('eraI', 'monthly', 'OMEGA', "Pa s-1", "Pressure Velocity")),

        # (joblist_create, "^eraI.monthly", ["HFLUX",],('eraI', 'monthly', 'SHF', 'Wm-2', "Sensible Heat Flux"),),
        # (joblist_create, "^eraI.monthly", ["EFLUX",],('eraI', 'monthly', 'LHF', 'Wm-2', "Latent Heat Flux"),),
    ]

    try:
        choice = int(sys.argv[1])
        assert(choice >=0 and choice < len(dispatch_table))
    except:
        print(("Did not understand specified argument. "
            " Require a number between 0-{0}".format(len(dispatch_table))) )
        pprint(list(enumerate(dispatch_table)))
        sys.exit(8)

    k = dispatch_table[choice]
    f = k[0]
    jl = f(col, k[1], k[2])
    glue_joblist_into_monthly_data(jl, *k[3])

    client.close()


if __name__ == '__main__':
    main()
