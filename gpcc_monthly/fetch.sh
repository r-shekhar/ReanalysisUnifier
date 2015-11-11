#!/bin/bash

wget 'ftp://ftp.cdc.noaa.gov/Datasets/gpcc/combined/precip.mon.combined.total.v6.nc'
wget 'ftp://ftp.cdc.noaa.gov/Datasets/gpcc/full_v6/precip.mon.total.v6.nc'
wget 'ftp://ftp.cdc.noaa.gov/Datasets/gpcc/first_guess/precip.first.mon.total.1x1.nc'

echo ""

echo "For 1.0° grid resolution: Schneider, Udo; Becker, Andreas; Finger, Peter; Meyer-Christoffer, Anja; Rudolf, Bruno; Ziese, Markus (2011): GPCC Full Data Reanalysis Version 6.0 at 1.0°: Monthly Land-Surface Precipitation from Rain-Gauges built on GTS-based and Historic Data. DOI: 10.5676/DWD_GPCC/FD_M_V6_100"
echo ""

echo "If you acquire GPCC Precipitation data products from PSD, we ask that you acknowledge us in your use of the data. This may be done by including text such as GPCC Precipitation data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their Web site at http://www.esrl.noaa.gov/psd/ in any documents or publications using these data. We would also appreciate receiving a copy of the relevant publications. This will help PSD to justify keeping the GPCC Precipitation data set freely available online in the future. Thank you!"
