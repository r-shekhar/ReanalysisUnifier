#!/usr/bin/env python

import spharm
import _spherepack
import numpy as np
from assemble import create_output_file
import netCDF4


def create_sfn_velpot_vortdiv(reanal):
    ds_U = netCDF4.Dataset(
        'reanalysis_clean/{0}.monthly.U.nc'.format(reanal))
    ds_VOR = netCDF4.Dataset(
        'reanalysis_clean/{0}.monthly.VORTICITY.nc'.format(reanal))
    ds_DIV = netCDF4.Dataset(
        'reanalysis_clean/{0}.monthly.DIVERGENCE.nc'.format(reanal))

    U = ds_U.variables['U']
    VOR = ds_VOR.variables['VORTICITY']
    DIV = ds_DIV.variables['DIVERGENCE']

    ntime, nlev, nlat, nlon = U.shape
    assert(U.shape == VOR.shape)
    assert(U.shape == DIV.shape)

    out_fh_1 = create_output_file(reanal, 'monthly',
                                       'HORIZ_SFN', 'm2 s-1',
                                       "Atmospheric Horizontal Streamfunction",
                                       ds_U.variables['level'][:],
                                       ds_U.variables['latitude'][:],
                                       ds_U.variables['longitude'][:],
                                       noclobber=True,
                                       compress=True)
    out_fh_2 = create_output_file(reanal, 'monthly',
                                       'HORIZ_VEL_POT', 'm2 s-1',
                                       "Atmospheric Horizontal Streamfunction",
                                       ds_U.variables['level'][:],
                                       ds_U.variables['latitude'][:],
                                       ds_U.variables['longitude'][
                                           :], noclobber=True,
                                       compress=True)

    horiz_sfn = out_fh_1.variables['HORIZ_SFN']
    vel_pot = out_fh_2.variables['HORIZ_VEL_POT']
    time_1 = out_fh_1.variables['time']
    time_2 = out_fh_2.variables['time']

    lats = ds_U.variables['latitude'][:]
    lons = ds_U.variables['longitude'][:]

    # spharm requires grid to go from North to South
    # and from 0 to 360 positive
    # Some data can be from -180 to +180 but since a sphere is invariant under
    # rotations, that should be fine, as long as the direction is eastward.

    if lats[-1] > lats[0]:
        lats_increasing = True
        assert(np.allclose(np.linspace(-90, 90, nlat), lats, 1.E-5, 1.E-5))
    else:
        lats_increasing = False
        assert(np.allclose(np.linspace(90, -90, nlat), lats, 1.E-5, 1.E-5))
    if lons[-1] > lons[0]:
        lons_increasing = True
    else:
        lons_increasing = False

    # check if the grid is regular and increasing
    assert(lons[1]-lons[0] > 0.)
    assert(np.allclose(np.diff(lons), lons[1]-lons[0], 1.0E-4))

    psi = np.zeros(U[0].shape, dtype=np.float32)
    chi = np.zeros(U[0].shape, dtype=np.float32)

    # this could be written in a much faster way, but it's fast enough for now
    s = spharm.Spharmt(nlon=nlon, nlat=nlat)
    for itime in range(ntime):
        print("{0}/{1}".format(itime+1, ntime))

        time_1[itime] = ds_U.variables['time'][itime]
        time_2[itime] = ds_U.variables['time'][itime]

        vor_current = VOR[itime]
        div_current = DIV[itime]

        if type(vor_current) is np.ma.core.MaskedArray:
            vor_current = vor_current.filled(0.)
        if type(div_current) is np.ma.core.MaskedArray:
            div_current = div_current.filled(0.)

        if lats_increasing:
            vor_current = vor_current[:, ::-1, :]
            div_current = div_current[:, ::-1, :]
        if not lons_increasing:
            vor_current = vor_current[:, :, ::-1]
            div_current = div_current[:, :, ::-1]

        for ilev in range(nlev):
            print("\t{0}".format(ilev+1))

            vor_spec = s.grdtospec(vor_current[ilev])
            div_spec = s.grdtospec(div_current[ilev])

            psi_spec = _spherepack.invlap(vor_spec, s.rsphere)
            chi_spec = _spherepack.invlap(div_spec, s.rsphere)

            psi_current = np.squeeze(s.spectogrd(psi_spec))
            chi_current = np.squeeze(s.spectogrd(chi_spec))

            print("\t\t{0:12.4g}\t{1:12.4g}".format(
                np.mean(psi_current), np.mean(chi_current)))

            psi[ilev] = psi_current
            chi[ilev] = chi_current

            assert(not (np.allclose(psi[ilev], chi[ilev], 1.0E-6, 1.0E-6)))

        if lats_increasing:
            psi = psi[:, ::-1, :]
            chi = chi[:, ::-1, :]
        if not lons_increasing:
            psi = psi[:, :, ::-1]
            chi = chi[:, :, ::-1]

        horiz_sfn[itime] = psi
        vel_pot[itime] = chi

    if itime % 10 == 0:
        out_fh_1.sync()
        out_fh_2.sync()

    out_fh_1.close()
    out_fh_2.close()

def main():
    import sys
    for s in sys.argv[1:]:
        create_sfn_velpot_vortdiv(s)

if __name__ == '__main__':
    main()
