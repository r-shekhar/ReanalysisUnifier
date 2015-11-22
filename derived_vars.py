#!/usr/bin/env python

import os
import sys
import numpy as np
import iris
import atmos_thermo
import xray
import functools
from pprint import pprint


def varpath(reanal, variable, timeres='monthly'):
    path_template = 'reanalysis_clean/{0}.{1}.{2}.nc'
    return path_template.format(reanal, timeres, variable)


def calc_formulas(data):
    """Do all the calculations here. Everything should be dask and therefore
    automatically chunked"""

    data['COL_MSE_SRC'] = (data['LHF'] + data['SHF']
                           - data['SLWNT'] - data['SSWNT']
                           - data['TLWUP'] + data['TSWNT']
                           )
    data['COL_MSE_SRC'].long_name = 'Column MSE Source'

    data['COL_MSE_SURF_FORCING'] = (data['LHF'] + data['SHF'])
    data['COL_MSE_SURF_FORCING'].long_name = 'Column MSE Surface Forcing'

    data['COL_MSE_SW_FORCING'] = (-data['SSWNT'] + data['TSWNT'])
    data['COL_MSE_SW_FORCING'].long_name = 'Column MSE Shortwave Forcing'

    data['COL_MSE_LW_FORCING'] = (-data['SLWNT'] - data['TLWUP'])
    data['COL_MSE_LW_FORCING'].long_name = 'Column MSE Longwave Forcing'

    data['COL_MSE_SW_CLRSKY_FORCING'] = (-data['SSWNT_CLRSKY']
                                         + data['TSWNT_CLRSKY'])
    data['COL_MSE_SW_CLRSKY_FORCING'].long_name = \
        'Column MSE Shortwave Clear Sky Forcing'

    data['COL_MSE_LW_CLRSKY_FORCING'] = (-data['SLWNT_CLRSKY']
                                         - data['TLWUP_CLRSKY'])
    data['COL_MSE_LW_CLRSKY_FORCING'].long_name = \
        'Column MSE Longwave Clear Sky Forcing'

    data['COL_MSE_RAD_FORCING'] = (- data['SLWNT'] - data['SSWNT']
                                   - data['TLWUP'] + data['TSWNT'])
    data['COL_MSE_RAD_FORCING'].long_name = \
        "Column MSE Radiation Forcing"

    data['COL_MSE_RAD_CLRSKY_FORCING'] = (
        - data['SLWNT_CLRSKY'] - data['SSWNT_CLRSKY']
        - data['TLWUP_CLRSKY'] + data['TSWNT_CLRSKY'])
    data['COL_MSE_RAD_CLRSKY_FORCING'].long_name = \
        "Column MSE Radiation Clear Sky Forcing"

    data['COL_MSE_RAD_CLOUD_FORCING'] = (
        data['COL_MSE_RAD_FORCING'] - data['COL_MSE_RAD_CLRSKY_FORCING'])
    data['COL_MSE_RAD_CLOUD_FORCING'].long_name = \
        "Column MSE Radiation Cloud Forcing"

    data['COL_MSE_LW_CLOUD_FORCING'] = (
        data['COL_MSE_LW_FORCING'] - data['COL_MSE_LW_CLRSKY_FORCING'])
    data['COL_MSE_LW_CLOUD_FORCING'].long_name = \
        "Column MSE Longwave Cloud Forcing"

    data['COL_MSE_SW_CLOUD_FORCING'] = (
        data['COL_MSE_SW_FORCING'] - data['COL_MSE_SW_CLRSKY_FORCING'])
    data['COL_MSE_SW_CLOUD_FORCING'].long_name = \
        "Column MSE Shortwave Cloud Forcing"

    if data['GHT'].units == 'm-2 s-2':
        data['GHT'] /= atmos_thermo.cearth.g
        data['GHT'].units = 'm'

    data['MSE'] = atmos_thermo.h_from_r_T_z(data['SPHUM'], data['T'],
                                            data['GHT'])

    pressure_levels = data['T'].coords['level'].values
    if np.max(pressure_levels < 2000.):  # check if units are in hPa
        pressure_levels *= 100  # fix units.

    data['MSE_SATURATED'] = atmos_thermo.hstar_classical_from_p_T_z(
        pressure_levels[None, None, :, None], data['T'],
        data['GHT'])


def load_write_data(reanal):
    open_dset = functools.partial(xray.open_dataset, chunks={'time': 6})

    vars_to_load = '''
    SHF LHF SSWNT TSWNT SLWNT TLWUP
    SSWNT_CLRSKY SLWNT_CLRSKY TSWNT_CLRSKY TLWUP_CLRSKY
    GHT T SPHUM
    '''.split()

    dsets = {}
    data = {}
    for v in vars_to_load:
        dsets[v] = open_dset(varpath(reanal, v))
        data[v] = getattr(dsets[v], v)

    calc_formulas(data)

    vars_to_write = [v for v in data.keys() if v not in vars_to_load]
    for v in vars_to_write:
        if os.path.isfile(varpath(reanal, v)):
            print("File {0} exists. Skipping.".format(varpath(reanal, v)))
            continue
        print("Calculating and writing {0}".format(varpath(reanal, v)))
        dset = xray.Dataset()
        if type(data[v]) == type(dset):
            data[v].T.to_netcdf(varpath(reanal, v), format='NETCDF3_64BIT')
        else:
            dset[v] = data[v]
            dset.to_netcdf(varpath(reanal, v), format='NETCDF3_64BIT')
        print("File {0} complete.".format(varpath(reanal, v)))


def main():
    # reanalyses = "erai cfsr merra merra2".split()
    # N_reanal = len(reanalyses)

    for r in sys.argv[1:]:
        load_write_data(r)


if __name__ == '__main__':
    main()
