# ReanalysisUnifier
Produces a unified set of consistent netCDF files for several atmospheric reanalyses. 

All of the major atmospheric reanalyses use vastly different data representation methods and output formats. This causes headaches for someone who would potentially want to compare them or use them to get evidence of climate phenomena. This project attempts to come up with a very restricted subset of data that can be consistently accessed across several datasets. To that end, only the following data fields will be included.

Spatial Resolution: 
  Highest resolution of original data available on a regular (non-gaussian) grid.
Temporal Resolution:
  For now, only monthly data is supported
Vertical Resolution
  Model data is only for pressure levels, or single level for fluxes
  
Only the following data fields are supported. In the case of multiple forecasts, only the "best guess" is included.
  - Air Temperature
  - Specific Humidity
  - Geopotential
  - Winds (U, V, omega)
  - Latent Heat Flux, Sensible Heat Flux
  - Shortwave and Longwave Radiation, with or without Clear Sky
  - Gridded precipitation in precipitation datasets
  
Datasets that are slated for inclusion.
  - GPCP
  - GPCC
  - ERA-Interim Monthly
  - CFSR, CFSv2
  - MERRA
  - MERRA-2
  
For now, no data will be made available, only code where you can generate the unified files yourself. 
