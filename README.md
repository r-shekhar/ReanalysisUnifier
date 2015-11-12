# ReanalysisUnifier
Produces a unified set of consistent netCDF files for several atmospheric reanalyses. 

All of the major atmospheric reanalyses use vastly different data representation methods and output formats. This causes headaches for someone who would potentially want to compare them or use them to get evidence of climate phenomena. This project attempts to come up with a very restricted subset of data that can be consistently accessed across several datasets. To that end, only the following data fields will be included.

In the case of multiple forecasts, only the "best guess" is included. All fields are deaccumulated if necessary. 
  - Air Temperature
  - Specific Humidity
  - Geopotential
  - Winds (U, V, omega)
  - Latent Heat Flux, Sensible Heat Flux
  - Surface Pressure, Pressure at Mean Sea Level
  - Topography
  - Shortwave and Longwave Radiation, with or without Clear Sky
  - Gridded precipitation in precipitation datasets
  
Spatial Resolution: 
  Highest resolution of original data available on a regular (non-gaussian) grid.
Temporal Resolution:
  For now, only monthly data is supported
Vertical Resolution:
  Model data is only for pressure levels, or single level for fluxes

Datasets that are slated for inclusion.
  - GPCP
  - GPCC
  - ERA-Interim Monthly
  - CFSR, CFSv2
  - MERRA
  - MERRA-2
  
For now, no data will be made available, only code where you can download and generate the unified files yourself. 

# Usage

The code (or procedure) used to fetch each dataset is in it's respective folder. Generally you can run the fetch script, but sometimes, following the instructions will be required. Or copy that fetch script to a more appropriate folder and symlink the data back to the directory. For example, I copy the `merra_monthly/*` to a directory /scratch/data/merra_monthly. I download the files, and symlink it to merra_monthly here by `ln -sf /scratch/data/merra_monthly/*nc merra_monthly/`.

Because managing the files is such a nightmare, I create a mongodb database with all of the metadata from the netCDF files present in the directory. This is accomplished by starting `mongod` in a local directory (search google for more info). The file `create_netcdf_database.py` indexes the metadata in the netCDF files and puts it into the mongodb instance. This is something that is queried for later steps.
