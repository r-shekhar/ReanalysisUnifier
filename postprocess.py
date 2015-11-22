#!/usr/bin/env ipython

from __future__ import print_function
import netCDF4
#import shutil

from assemble import create_output_file


def calc_CFSR_net(var1, var2, new_name, new_description):
    "var1 - var2 = new_vame is the formula applied."

    print("Calculating {0}".format(new_name))
    fh_in_1 = netCDF4.Dataset(
        'reanalysis_clean/cfsr.monthly.{0}.nc'.format(var1), 'r')
    fh_in_2 = netCDF4.Dataset(
        'reanalysis_clean/cfsr.monthly.{0}.nc'.format(var2), 'r')

    # create_output_file(reanalysis, timeres,
    # field, field_units, field_long_name,
    # level, latitude, longitude):

    fh_out = create_output_file("cfsr", "monthly", new_name, "W m-2",
                                new_description,
                                None,
                                fh_in_1.variables['latitude'][:],
                                fh_in_1.variables['longitude'][:],
                                noclobber=False)
    fh_out.variables[new_name][:] = fh_in_1[var1][:] - fh_in_2[var2][:]
    fh_out.variables['time'][:] = fh_in_1['time'][:]
    fh_out.close()
    fh_in_1.close()
    fh_in_2.close()

#    shutil.move('reanalysis_clean/cfsr.monthly.{0}.nc'.format(var1),
#                'reanalysis_clean/_unused_cfsr.monthly.{0}.nc.bak'.format(var1)
#                )
#    shutil.move('reanalysis_clean/cfsr.monthly.{0}.nc'.format(var2),
#                'reanalysis_clean/_unused_cfsr.monthly.{0}.nc.bak'.format(var2)
#                )


def calc_ERAI_rename_flipsign(var1, new_name, new_description):
    "-var1  = new_vame is the formula applied."

    print("Calculating {0}".format(new_name))
    fh_in_1 = netCDF4.Dataset(
        'reanalysis_clean/erai.monthly.{0}.nc'.format(var1), 'r')

    fh_out = create_output_file("erai", "monthly", new_name, "W m-2",
                                new_description,
                                None,
                                fh_in_1.variables['latitude'][:],
                                fh_in_1.variables['longitude'][:],
                                noclobber=False)
    fh_out.variables[new_name][:] = -1.0 * fh_in_1[var1][:]
    fh_out.variables['time'][:] = fh_in_1['time'][:]
    fh_out.close()
    fh_in_1.close()
#    shutil.move('reanalysis_clean/erai.monthly.{0}.nc'.format(var1),
#                'reanalysis_clean/_unused_erai.monthly.{0}.nc.bak'.format(var1)
#                )    

def main():
    print("Fixing CFSR.")
    calc_CFSR_net("SLWDN", "SLWUP", "SLWNT", "Longwave Net at Surface")
    calc_CFSR_net("SSWDN", "SSWUP", "SSWNT", "Shortwave Net at Surface")
    calc_CFSR_net("TSWDN", "TSWUP", "TSWNT", "Shortwave Net at TOA")

    calc_CFSR_net("SLWDN_CLRSKY", "SLWUP_CLRSKY", "SLWNT_CLRSKY",
                  "Longwave Net at Surface, Clear Sky")
    calc_CFSR_net("SSWDN_CLRSKY", "SSWUP_CLRSKY", "SSWNT_CLRSKY",
                  "Shortwave Net at Surface, Clear Sky")
    calc_CFSR_net("TSWDN", "TSWUP_CLRSKY", "TSWNT_CLRSKY",
                  "Shortwave Net at TOA, Clear Sky")

    print("Fixing ERA-I")

    fh = netCDF4.Dataset('reanalysis_clean/erai.monthly.LHF.nc', 'a')
    if not (hasattr(fh.variables['LHF'], 'postprocessed')):
        fh.variables['LHF'][:] = -1.0 * (fh.variables['LHF'][:])
        fh.variables['LHF'].postprocessed = "True"
    fh.close()
    print("LHF fixed.")

    fh = netCDF4.Dataset('reanalysis_clean/erai.monthly.SHF.nc', 'a')
    if not (hasattr(fh.variables['SHF'], 'postprocessed')):
        fh.variables['SHF'][:] = -1.0 * (fh.variables['SHF'][:])
        fh.variables['SHF'].postprocessed = "True"
    fh.close()
    print("SHF Fixed")

    calc_ERAI_rename_flipsign("TLWNT", "TLWUP", "Longwave Up at TOA")
    calc_ERAI_rename_flipsign("TLWNT_CLRSKY", "TLWUP_CLRSKY",
                              "Longwave Up at TOA, Clear Sky")

    print("All Done")


if __name__ == '__main__':
    main()
