#!/usr/bin/env python

import pymongo
MongoClient = pymongo.MongoClient
from pprint import pprint
import itertools
import functools
import multiprocessing

import numpy as np
import pandas as pd
import netCDF4
import sys


def joblist_cfsr_flatvar(col, varName):
    print("Querying database for CFSR {0}".format(varName))
    q = {}
    q['filename_on_disk'] = {"$regex": "^cfsr.monthly.*"}
    q['varnames'] = {"$in": [varName]}

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
        variables.extend([varName]*n)
        i += 1
    # print(i)

    d = {'filenames': filenames, 'datetimes': datetimes, 'indices': indices,
         'variables': variables}
    df = pd.DataFrame(d)
    df = df.sort_values(by='datetimes')
    dt = np.array(df.datetimes, dtype='M8[h]')
    d2 = dt[1:] - dt[:-1]
    assert(np.all(d2 == np.timedelta64(6, 'h')))
    return df


def joblist_cfsr_lhf(col):
    q = {}
    q['filename_on_disk'] = {"$regex": "^cfsr.monthly.*"}
    q['varnames'] = {"$in": ["LHTFL_L1_Avg_1"]}

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
        variables.extend(['LHTFL_L1_Avg_1']*n)
        i += 1
    print(i)

    d = {'filenames': filenames, 'datetimes': datetimes, 'indices': indices,
         'variables': variables}
    df = pd.DataFrame(d)
    # print(df)
    df = df.sort_values(by='datetimes')
    dt = np.array(df.datetimes, dtype='M8[h]')
    d2 = dt[1:] - dt[:-1]
    assert(np.all(d2 == np.timedelta64(6, 'h')))
    return df


def joblist_cfsr_shf(col):
    q = {}
    q['filename_on_disk'] = {"$regex": "^cfsr.monthly.*"}
    q['varnames'] = {"$in": ["SHTFL_L1_Avg_1"]}

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
        variables.extend(['LHTFL_L1_Avg_1']*n)
        i += 1
    print(i)

    d = {'filenames': filenames, 'datetimes': datetimes, 'indices': indices,
         'variables': variables}
    df = pd.DataFrame(d)
    df = df.sort_values(by='datetimes')
    dt = np.array(df.datetimes, dtype='M8[h]')
    d2 = dt[1:] - dt[:-1]
    assert(np.all(d2 == np.timedelta64(6, 'h')))
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


    # print(k[0], k[1], k[2].shape, k[3])

    # data_iter = imap(fetch_data, joblist.itertuples())
    # for j in data_iter:
    #     print((j[0], j[1], j[2].shape))

    return


def fetch_data(t):
    new_index, dt, fn, old_index, varname = t
    fh = netCDF4.Dataset(fn, 'r')
    d = fh.variables[varname][old_index]
    dcoords = []
    for z in fh.variables[varname].dimensions[1:]:
        dcoords.append(fh.variables[z][:])
    fh.close()

    return ((new_index, dt, d, dcoords))


def main():
    client = MongoClient()
    db = client.rawdata
    col = db.netcdf


    dispatch_table = [
        (joblist_cfsr_flatvar, "SHTFL_L1_Avg_1", ('cfsr', '6h', 'SHF', 'Wm-2', "Sensible Heat Flux"),),
        (joblist_cfsr_flatvar, "LHTFL_L1_Avg_1", ('cfsr', '6h', 'LHF', 'Wm-2', "Latent Heat Flux"),),
        (joblist_cfsr_flatvar, "CSDLF_L1_Avg_1", ('cfsr', '6h', 'SLWDN_CLRSKY', 'Wm-2', "Longwave Down at Surface, Clear Sky"),),
        (joblist_cfsr_flatvar, "CSDSF_L1_Avg_1", ('cfsr', '6h', 'SSWDN_CLRSKY', 'Wm-2', "Shortwave Down at Surface, Clear Sky"),),
        (joblist_cfsr_flatvar, "CSULF_L1_Avg_1", ('cfsr', '6h', 'SLWUP_CLRSKY', 'Wm-2', "Longwave Up at Surface, Clear Sky"),),
        (joblist_cfsr_flatvar, "CSUSF_L1_Avg_1", ('cfsr', '6h', 'SSWUP_CLRSKY', 'Wm-2', "Shortwave Up at Surface, Clear Sky"),),
        (joblist_cfsr_flatvar, "CSULF_L8_Avg_1", ('cfsr', '6h', 'TLWUP_CLRSKY', 'Wm-2', "Longwave Up at TOA, Clear Sky"),),
        (joblist_cfsr_flatvar, "DSWRF_L8_Avg_1", ('cfsr', '6h', 'TSWDN', 'Wm-2', "Shortwave Down at TOA"),),
        (joblist_cfsr_flatvar, "USWRF_L8_Avg_1", ('cfsr', '6h', 'TSWUP', 'Wm-2', "Shortwave UP at TOA"),),
        (joblist_cfsr_flatvar, "ULWRF_L8_Avg_1", ('cfsr', '6h', 'TLWUP', 'Wm-2', "Longwave Up at TOA"),),
        (joblist_cfsr_flatvar, "DLWRF_L1_Avg_1", ('cfsr', '6h', 'SLWDN', 'Wm-2', "Longwave Down at Surface"),),
        (joblist_cfsr_flatvar, "ULWRF_L1_Avg_1", ('cfsr', '6h', 'SLWUP', 'Wm-2', "Longwave Up at Surface"),),
        (joblist_cfsr_flatvar, "DSWRF_L1_Avg_1", ('cfsr', '6h', 'SSWDN', 'Wm-2', "Shortwave Down at Surface"),),
        (joblist_cfsr_flatvar, "USWRF_L1_Avg_1", ('cfsr', '6h', 'SSWUP', 'Wm-2', "Shortwave Up at Surface"),),
        (joblist_cfsr_flatvar, "GFLUX_L1_Avg_1", ('cfsr', '6h', 'GHF', 'Wm-2', "Ground Heat Flux"),),
    ]

    try:
        choice = int(sys.argv[1])
        assert(choice >=0 and choice < len(dispatch_table))
    except:
        print("Did not understand specified argument. Require a number between 0-15")
        sys.exit(8)

    k = dispatch_table[choice]
    f = k[0]
    jl = f(col, k[1])
    glue_joblist_into_data(jl, *k[2])

    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "SHTFL_L1_Avg_1"), 
    #     'cfsr', '6h', 'SHF', 'Wm-2', "Sensible Heat Flux")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "LHTFL_L1_Avg_1"), 
    #     'cfsr', '6h', 'LHF', 'Wm-2', "Latent Heat Flux")

    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "CSDLF_L1_Avg_1"), 
    #     'cfsr', '6h', 'SLWDN_CLRSKY', 'Wm-2',
    #     "Longwave Down at Surface, Clear Sky")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "CSDSF_L1_Avg_1"), 
    #     'cfsr', '6h', 'SSWDN_CLRSKY', 'Wm-2',
    #     "Shortwave Down at Surface, Clear Sky")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "CSULF_L1_Avg_1"), 
    #     'cfsr', '6h', 'SLWUP_CLRSKY', 'Wm-2',
    #     "Longwave Up at Surface, Clear Sky")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "CSUSF_L1_Avg_1"), 
    #     'cfsr', '6h', 'SSWUP_CLRSKY', 'Wm-2',
    #     "Shortwave Up at Surface, Clear Sky")

    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "CSULF_L8_Avg_1"), 
    #     'cfsr', '6h', 'TLWUP_CLRSKY', 'Wm-2',
    #     "Longwave Up at TOA, Clear Sky")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "DSWRF_L8_Avg_1"), 
    #     'cfsr', '6h', 'TSWDN', 'Wm-2', "Shortwave Down at TOA")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "USWRF_L8_Avg_1"), 
    #     'cfsr', '6h', 'TSWUP', 'Wm-2', "Shortwave UP at TOA")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "ULWRF_L8_Avg_1"), 
    #     'cfsr', '6h', 'TLWUP', 'Wm-2', "Longwave Up at TOA")

    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "DLWRF_L1_Avg_1"), 
    #     'cfsr', '6h', 'SLWDN', 'Wm-2', "Longwave Down at Surface")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "ULWRF_L1_Avg_1"), 
    #     'cfsr', '6h', 'SLWUP', 'Wm-2', "Longwave Up at Surface")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "DSWRF_L1_Avg_1"), 
    #     'cfsr', '6h', 'SSWDN', 'Wm-2', "Shortwave Down at Surface")
    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "USWRF_L1_Avg_1"), 
    #     'cfsr', '6h', 'SSWUP', 'Wm-2', "Shortwave Up at Surface")

    # glue_joblist_into_data(
    #     joblist_cfsr_flatvar(col, "GFLUX_L1_Avg_1"), 
    #     'cfsr', '6h', 'GHF', 'Wm-2', "Ground Heat Flux")

    client.close()

    pool.terminate()
    del pool


if __name__ == '__main__':
    main()
