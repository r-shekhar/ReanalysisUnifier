#!/usr/bin/env python

from __future__ import division, print_function

import os
import sys
import numpy as np
import iris
import atmos_thermo
import netCDF4

from assemble import create_output_file


def varpath(reanal, variable, timeres='monthly'):
    path_template = 'reanalysis_clean/{0}.{1}.{2}.nc'
    return path_template.format(reanal, timeres, variable)


def clone_netcdf_skeleton(reanal, dsets, dset_variable, new_variable,
                          long_name, units, timeres='monthly'):
    new_fn = varpath(reanal, new_variable)

    dset = dsets[dset_variable]

    if 'level' in dset.variables:
        level = dset.variables['level'][:]
    else:
        level = None
    latitude = dset.variables['latitude'][:]
    longitude = dset.variables['longitude'][:]

    fh = create_output_file(reanal, timeres,
                            new_variable, units, long_name,
                            level, latitude, longitude, noclobber=False)
    fh.variables['time'][:] = dset.variables['time'][:]
    return fh


def apply_linear_formula(outvar, formula):

    print("Starting variable {0}".format(outvar.name))
    shape0 = formula[0][1].shape
    for i in range(len(formula)):
        assert(len(formula[i]) == 2)
        assert(formula[i][1].shape == shape0)

    # per_timestep_size = np.product(shape0[1:])

    # # we aim for a chunk size of 16MB per variable.
    # # 2**22 is 4M, 4 bytes/value
    # stride = max(int(2**22/per_timestep_size/4), 1)

    # N_strides = int(shape0[0] / stride)
    # if shape0[0] % stride != 0:
    #     N_strides += 1
    # coeffs = np.array([f[0] for f in formula], dtype=np.float32)

    # for istride in range(N_strides):
    #     sys.stdout.write("{0} ".format(istride*stride))
    #     sys.stdout.flush()
    #     sli = slice(istride*stride, (istride+1)*stride)

    #     # loop over the variables, grab the slice subset, turn it into
    #     # numpy array with variable as the zeroth axis
    #     arrs = np.array([f[1][sli] for f in formula])
    #     # dot it with coeffs. tensor contraction. last (only) axis of coeffs
    #     # and the zeroth axis of arrs.
    #     # print(coeffs.shape)
    #     # print(arrs.shape)
    #     j = np.tensordot(coeffs, arrs, axes=1)
    #     # print(j.shape)
    #     # print(outvar[sli].shape)
    #     outvar[sli] = j

    # For some reason the strided code seems to produce inconsistent results.
    # Some runs work fine, a repeated invocation produces garbage results.
    # Maybe some sort of multithreaded race condition? This code actually
    # performs much better. Different multithreaded code is called internally
    #  within the BLAS library for tensordot, but it works out better.

    coeffs = np.array([f[0] for f in formula], dtype=np.float32)
    for itimestep in range(shape0[0]):
        arrs = np.array([f[1][itimestep] for f in formula])
        outvar[itimestep] = np.tensordot(coeffs, arrs, axes=1)
        sys.stdout.write("{0} ".format(itimestep))
        sys.stdout.flush()

    print("\nCompleted variable {0}".format(outvar.name))


def calc_derived(reanal, dsets, data):
    """Do all the calculations here."""

    print("Starting reanalysis {0}".format(reanal))
    
    fh = clone_netcdf_skeleton(reanal, dsets, "LHF", "COL_MSE_SRC",
                               "Column MSE Source", "W m-2")
    apply_linear_formula(fh['COL_MSE_SRC'], formula=(
        (1, data['LHF']),
        (1, data['SHF']),
        (-1., data['SLWNT']),
        (-1., data['SSWNT']),
        (-1., data['TLWUP']),
        (1., data['TSWNT'])
    ))
    fh.close()

    # data['COL_MSE_SRC'] = (data['LHF'] + data['SHF']
    #                        - data['SLWNT'] - data['SSWNT']
    #                        - data['TLWUP'] + data['TSWNT']
    #                        )
    # data['COL_MSE_SRC'].long_name = 'Column MSE Source'

    fh = clone_netcdf_skeleton(reanal, dsets, "LHF", "COL_MSE_SURF_FORCING",
                               "Column MSE Source", "W m-2")
    apply_linear_formula(fh['COL_MSE_SURF_FORCING'],
                         formula=((1, data['LHF']),
                                  (1, data['SHF']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_SURF_FORCING'] = (data['LHF'] + data['SHF'])
    # data['COL_MSE_SURF_FORCING'].long_name = 'Column MSE Surface Forcing'

    fh = clone_netcdf_skeleton(reanal, dsets, "SSWNT", "COL_MSE_SW_FORCING",
                               "Column MSE Shortwave Forcing", "W m-2")
    apply_linear_formula(fh['COL_MSE_SW_FORCING'],
                         formula=((-1., data['SSWNT']),
                                  (1., data['TSWNT']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_SW_FORCING'] = (-data['SSWNT'] + data['TSWNT'])
    # data['COL_MSE_SW_FORCING'].long_name = 'Column MSE Shortwave Forcing'

    fh = clone_netcdf_skeleton(reanal, dsets, "SSWNT", "COL_MSE_LW_FORCING",
                               "Column MSE Longwave Forcing", "W m-2")
    apply_linear_formula(fh['COL_MSE_LW_FORCING'],
                         formula=((-1., data['SLWNT']),
                                  (-1., data['TLWUP']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_LW_FORCING'] = (-data['SLWNT'] - data['TLWUP'])
    # data['COL_MSE_LW_FORCING'].long_name = 'Column MSE Longwave Forcing'

    fh = clone_netcdf_skeleton(reanal, dsets, "SSWNT",
                               "COL_MSE_SW_CLRSKY_FORCING",
                               "Column MSE Shortwave Clear Sky Forcing",
                               "W m-2")
    apply_linear_formula(fh['COL_MSE_SW_CLRSKY_FORCING'],
                         formula=((-1., data['SSWNT_CLRSKY']),
                                  (1., data['TSWNT_CLRSKY']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_SW_CLRSKY_FORCING'] = (-data['SSWNT_CLRSKY']
    #                                      + data['TSWNT_CLRSKY'])
    # data['COL_MSE_SW_CLRSKY_FORCING'].long_name = \
    #     'Column MSE Shortwave Clear Sky Forcing'

    fh = clone_netcdf_skeleton(reanal, dsets, "SSWNT",
                               "COL_MSE_LW_CLRSKY_FORCING",
                               "Column MSE Longwave Clear Sky Forcing",
                               "W m-2")
    apply_linear_formula(fh['COL_MSE_LW_CLRSKY_FORCING'],
                         formula=((-1., data['SLWNT_CLRSKY']),
                                  (-1., data['TLWUP_CLRSKY']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_LW_CLRSKY_FORCING'] = (-data['SLWNT_CLRSKY']
    #                                      - data['TLWUP_CLRSKY'])
    # data['COL_MSE_LW_CLRSKY_FORCING'].long_name = \
    #     'Column MSE Longwave Clear Sky Forcing'

    fh = clone_netcdf_skeleton(reanal, dsets, "SSWNT",
                               "COL_MSE_RAD_FORCING",
                               "Column MSE Radiation Forcing",
                               "W m-2")
    apply_linear_formula(fh['COL_MSE_RAD_FORCING'],
                         formula=((-1., data['SLWNT']),
                                  (-1., data['SSWNT']),
                                  (-1., data['TLWUP']),
                                  (1., data['TSWNT']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_RAD_FORCING'] = (- data['SLWNT'] - data['SSWNT']
    #                                - data['TLWUP'] + data['TSWNT'])
    # data['COL_MSE_RAD_FORCING'].long_name = \
    #     "Column MSE Radiation Forcing"

    fh = clone_netcdf_skeleton(reanal, dsets, "SLWNT_CLRSKY",
                               "COL_MSE_RAD_CLRSKY_FORCING",
                               "Column MSE Radiation Clear Sky Forcing",
                               "W m-2")
    apply_linear_formula(fh['COL_MSE_RAD_CLRSKY_FORCING'],
                         formula=((-1., data['SLWNT_CLRSKY']),
                                  (-1., data['SSWNT_CLRSKY']),
                                  (-1., data['TLWUP_CLRSKY']),
                                  (1., data['TSWNT_CLRSKY']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_RAD_CLRSKY_FORCING'] = (
    #     - data['SLWNT_CLRSKY'] - data['SSWNT_CLRSKY']
    #     - data['TLWUP_CLRSKY'] + data['TSWNT_CLRSKY'])
    # data['COL_MSE_RAD_CLRSKY_FORCING'].long_name = \
    #     "Column MSE Radiation Clear Sky Forcing"

    fh = clone_netcdf_skeleton(reanal, dsets, "SLWNT_CLRSKY",
                               "COL_MSE_RAD_CLOUD_FORCING",
                               "Column MSE Radiation Forcing",
                               "W m-2")
    apply_linear_formula(fh['COL_MSE_RAD_CLOUD_FORCING'],
                         formula=((-1., data['SLWNT']),
                                  (-1., data['SSWNT']),
                                  (-1., data['TLWUP']),
                                  (1., data['TSWNT']),
                                  (1., data['SLWNT_CLRSKY']),
                                  (1., data['SSWNT_CLRSKY']),
                                  (1., data['TLWUP_CLRSKY']),
                                  (-1., data['TSWNT_CLRSKY']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_RAD_CLOUD_FORCING'] = (
    #     data['COL_MSE_RAD_FORCING'] - data['COL_MSE_RAD_CLRSKY_FORCING'])
    # data['COL_MSE_RAD_CLOUD_FORCING'].long_name = \
    #     "Column MSE Radiation Cloud Forcing"

    fh = clone_netcdf_skeleton(reanal, dsets, "SLWNT_CLRSKY",
                               "COL_MSE_LW_CLOUD_FORCING",
                               "Column MSE Longwave Cloud Forcing",
                               "W m-2")
    apply_linear_formula(fh['COL_MSE_LW_CLOUD_FORCING'],
                         formula=((-1., data['SLWNT']),
                                  (-1., data['TLWUP']),
                                  (1., data['SLWNT_CLRSKY']),
                                  (1., data['TLWUP_CLRSKY']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_LW_CLOUD_FORCING'] = (
    #     data['COL_MSE_LW_FORCING'] - data['COL_MSE_LW_CLRSKY_FORCING'])
    # data['COL_MSE_LW_CLOUD_FORCING'].long_name = \
    #     "Column MSE Longwave Cloud Forcing"

    fh = clone_netcdf_skeleton(reanal, dsets, "SLWNT_CLRSKY",
                               "COL_MSE_SW_CLOUD_FORCING",
                               "Column MSE Shortwave Cloud Forcing",
                               "W m-2")
    apply_linear_formula(fh['COL_MSE_SW_CLOUD_FORCING'],
                         formula=((-1., data['SSWNT']),
                                  (1., data['TSWNT']),
                                  (1., data['SSWNT_CLRSKY']),
                                  (-1., data['TSWNT_CLRSKY']),
                                  )
                         )
    fh.close()

    # data['COL_MSE_SW_CLOUD_FORCING'] = (
    #     data['COL_MSE_SW_FORCING'] - data['COL_MSE_SW_CLRSKY_FORCING'])
    # data['COL_MSE_SW_CLOUD_FORCING'].long_name = \
    #     "Column MSE Shortwave Cloud Forcing"

    # if data['GHT'].units == 'm-2 s-2':
    #     data['GHT'] /= atmos_thermo.cearth.g
    #     data['GHT'].units = 'm'

    fh = clone_netcdf_skeleton(reanal, dsets, "GHT",
                               "MSE",
                               "Moist Static Energy",
                               "J kg-1")
    g_effective = atmos_thermo.cearth.g
    apply_linear_formula(fh['MSE'],
                         formula=((atmos_thermo.catmos.C_pd, data['T']),
                                  (atmos_thermo.catmos.Lv0, data['SPHUM']),
                                  (g_effective, data['GHT']),
                                  )
                         )
    fh.close()

    print("Completed reanalysis {0}".format(reanal))


def load_write_data(reanal):

    vars_to_load = '''
    SHF LHF SSWNT TSWNT SLWNT TLWUP
    SSWNT_CLRSKY SLWNT_CLRSKY TSWNT_CLRSKY TLWUP_CLRSKY
    GHT T SPHUM
    '''.split()

    dsets = {}
    data = {}
    for v in vars_to_load:
        print(v)
        dsets[v] = netCDF4.Dataset(varpath(reanal, v))
        data[v] = dsets[v].variables[v]

    calc_derived(reanal, dsets, data)


def main():

    for r in sys.argv[1:]:
        load_write_data(r)


if __name__ == '__main__':
    main()
