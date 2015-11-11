# CFSR, CFSv2 Readme
------------------

CFSR goes from 1979-2010
CFSv2 goes from 2011 - current

So I went to the RDA website (http://rda.ucar.edu), and went to those two datasets (093.2 and 094.2 respectively). Unfortunately, some fields aren't available as monthly averages, most notably the year 2010.

So I downloaded the fluxes in daily mode for both CFS and CFSv2, all other fields in monthly mode for both datasets, except for 2010, where monthly means were not available, and I downloaded daily data instead.

The old fetch scripts (which should be invalid by now) are included to show what the filenames fetched were.

## Request 1
```
Subset details:
  Date range: 197901010000 to 201101010300
  Parameter(s): 
     Albedo
     Clear sky downward longwave flux
     Clear sky downward solar flux
     Clear sky upward longwave flux
     Clear sky upward solar flux
     Downward longwave radiation flux
     Downward shortwave radiation flux
     Ground heat flux
     Latent heat flux
     Sensible heat flux
     Upward longwave radiation flux
     Upward shortwave radiation flux
  Product(s):
    6-hour Average (initial+0 to initial+6)
  Grid: 0.5-deg x 0.5-deg from 0E to 359.5E and 90N to 90S (720 x 361 Longitude/Latitude)
  Output format conversion: netCDF
```

## Request 2

```
Subset details:
  Date range: 201101010000 to 201511110300
  Parameter(s): 
     Albedo
     Clear sky downward longwave flux
     Clear sky downward solar flux
     Clear sky upward longwave flux
     Clear sky upward solar flux
     Downward longwave radiation flux
     Downward shortwave radiation flux
     Ground heat flux
     Latent heat flux
     Sensible heat flux
     Upward longwave radiation flux
     Upward shortwave radiation flux
  Product(s):
    6-hour Average (initial+0 to initial+6)
  Grid: 0.5-deg x 0.5-deg from 0E to 359.5E and 90N to 90S (720 x 361 Longitude/Latitude)
  Output format conversion: netCDF

And the following fields in monthly mode
## Request 3
Subset details:
  Date range: 197901010000 to 201001010000
  Parameter(s): 
     Geopotential height
     Pressure
     Pressure reduced to MSL
     Specific humidity
     Temperature
     u-component of wind
     v-component of wind
     Vertical velocity (pressure)
  Level(s):
     Ground or water surface
     Isobaric surface: 1000 mbar
     Isobaric surface: 975 mbar
     Isobaric surface: 950 mbar
     Isobaric surface: 925 mbar
     Isobaric surface: 900 mbar
     Isobaric surface: 875 mbar
     Isobaric surface: 850 mbar
     Isobaric surface: 825 mbar
     Isobaric surface: 800 mbar
     Isobaric surface: 775 mbar
     Isobaric surface: 750 mbar
     Isobaric surface: 700 mbar
     Isobaric surface: 650 mbar
     Isobaric surface: 600 mbar
     Isobaric surface: 550 mbar
     Isobaric surface: 500 mbar
     Isobaric surface: 450 mbar
     Isobaric surface: 400 mbar
     Isobaric surface: 350 mbar
     Isobaric surface: 300 mbar
     Isobaric surface: 250 mbar
     Isobaric surface: 225 mbar
     Isobaric surface: 200 mbar
     Isobaric surface: 175 mbar
     Isobaric surface: 150 mbar
     Isobaric surface: 125 mbar
     Isobaric surface: 100 mbar
     Isobaric surface: 70 mbar
     Isobaric surface: 50 mbar
     Isobaric surface: 30 mbar
     Isobaric surface: 20 mbar
     Isobaric surface: 10 mbar
     Isobaric surface: 7 mbar
     Isobaric surface: 5 mbar
     Isobaric surface: 3 mbar
     Isobaric surface: 2 mbar
     Isobaric surface: 1 mbar
     Mean sea level
  Product(s):
    Monthly Mean (1 per day) of Analyses
  Grid: 0.5-deg x 0.5-deg from 0E to 359.5E and 90N to 90S (720 x 361 Longitude/Latitude)
  Output format conversion: netCDF
```

## Request 4
```
Subset details:
  Date range: 201101010000 to 201510010000
  Parameter(s): 
     Geopotential height
     Pressure
     Pressure reduced to MSL
     Specific humidity
     Temperature
     u-component of wind
     v-component of wind
     Vertical velocity (pressure)
  Level(s):
     Ground or water surface
     Isobaric surface: 1000 mbar
     Isobaric surface: 975 mbar
     Isobaric surface: 950 mbar
     Isobaric surface: 925 mbar
     Isobaric surface: 900 mbar
     Isobaric surface: 875 mbar
     Isobaric surface: 850 mbar
     Isobaric surface: 825 mbar
     Isobaric surface: 800 mbar
     Isobaric surface: 775 mbar
     Isobaric surface: 750 mbar
     Isobaric surface: 700 mbar
     Isobaric surface: 650 mbar
     Isobaric surface: 600 mbar
     Isobaric surface: 550 mbar
     Isobaric surface: 500 mbar
     Isobaric surface: 450 mbar
     Isobaric surface: 400 mbar
     Isobaric surface: 350 mbar
     Isobaric surface: 300 mbar
     Isobaric surface: 250 mbar
     Isobaric surface: 225 mbar
     Isobaric surface: 200 mbar
     Isobaric surface: 175 mbar
     Isobaric surface: 150 mbar
     Isobaric surface: 125 mbar
     Isobaric surface: 100 mbar
     Isobaric surface: 70 mbar
     Isobaric surface: 50 mbar
     Isobaric surface: 30 mbar
     Isobaric surface: 20 mbar
     Isobaric surface: 10 mbar
     Isobaric surface: 7 mbar
     Isobaric surface: 5 mbar
     Isobaric surface: 3 mbar
     Isobaric surface: 2 mbar
     Isobaric surface: 1 mbar
     Mean sea level
  Product(s):
    Monthly Mean (4 per day) of Analyses
  Grid: 0.5-deg x 0.5-deg from 0E to 359.5E and 90N to 90S (720 x 361 Longitude/Latitude)
  Output format conversion: netCDF
```

## Request 5

2010 is not available in monthly mean format for some reason, so this was downloaded daily (093.0)
```
Subset details:
  Date range: 201001010000 to 201101010300
  Parameter(s): 
     Geopotential height
     Pressure
     Pressure reduced to MSL
     Specific humidity
     Temperature
     u-component of wind
     v-component of wind
     Vertical velocity (pressure)
  Level(s):
     Ground or water surface
     Isobaric surface: 1000 mbar
     Isobaric surface: 975 mbar
     Isobaric surface: 950 mbar
     Isobaric surface: 925 mbar
     Isobaric surface: 900 mbar
     Isobaric surface: 875 mbar
     Isobaric surface: 850 mbar
     Isobaric surface: 825 mbar
     Isobaric surface: 800 mbar
     Isobaric surface: 775 mbar
     Isobaric surface: 750 mbar
     Isobaric surface: 700 mbar
     Isobaric surface: 650 mbar
     Isobaric surface: 600 mbar
     Isobaric surface: 550 mbar
     Isobaric surface: 500 mbar
     Isobaric surface: 450 mbar
     Isobaric surface: 400 mbar
     Isobaric surface: 350 mbar
     Isobaric surface: 300 mbar
     Isobaric surface: 250 mbar
     Isobaric surface: 225 mbar
     Isobaric surface: 200 mbar
     Isobaric surface: 175 mbar
     Isobaric surface: 150 mbar
     Isobaric surface: 125 mbar
     Isobaric surface: 100 mbar
     Isobaric surface: 70 mbar
     Isobaric surface: 50 mbar
     Isobaric surface: 30 mbar
     Isobaric surface: 20 mbar
     Isobaric surface: 10 mbar
     Isobaric surface: 7 mbar
     Isobaric surface: 5 mbar
     Isobaric surface: 3 mbar
     Isobaric surface: 2 mbar
     Isobaric surface: 1 mbar
     Mean sea level
  Product(s):
    Analysis
  Grid: 0.5-deg x 0.5-deg from 0E to 359.5E and 90N to 90S (720 x 361 Longitude/Latitude)
  Output format conversion: netCDF
```
