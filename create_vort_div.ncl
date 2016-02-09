setfileoption("nc", "FileStructure", "Advanced")
setfileoption("nc", "Format",  "NetCDF4")

;;;;;;;;;;; MERRA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fh_u = addfile("reanalysis_clean/merra.monthly.U.nc", "r");
fh_v = addfile("reanalysis_clean/merra.monthly.V.nc", "r");

u = fh_u->U;
v = fh_v->V;

vor = uv2vr_cfd(u, v, fh_u->latitude, fh_u->longitude, 3);
div = uv2dv_cfd(u, v, fh_u->latitude, fh_u->longitude, 3);

printVarSummary(vor);
printVarSummary(div);

vor!0 = "time";
vor!1 = "level";
vor!2 = "latitude";
vor!3 = "longitude";
vor&time = u&time
vor&level = u&level
vor&latitude = u&latitude
vor&longitude = u&longitude
vor@long_name = "Relative Vorticity"
vor@units = "s-1"

div!0 = "time";
div!1 = "level";
div!2 = "latitude";
div!3 = "longitude";
div&time = u&time
div&level = u&level
div&latitude = u&latitude
div&longitude = u&longitude
div@long_name = "Horizontal Divergence"
div@units = "s-1"


fh_vor = addfile("reanalysis_clean/merra.monthly.VORTICITY.nc" ,"c");
fh_div = addfile("reanalysis_clean/merra.monthly.DIVERGENCE.nc" ,"c");

fAtt               = True            ; assign file attributes
fAtt@Dataset       = "merra"
fAtt@Conventions   = "CF-1.0"
fAtt@creation_date = systemfunc ("date")
fileattdef( fh_vor, fAtt )            ; copy file attributes
fileattdef( fh_div, fAtt )            ; copy file attributes

fh_vor->VORTICITY = vor
fh_div->DIVERGENCE = div

delete([/u, v, fh_vor, fh_div, vor, div/])

;;;;;;;;;;; MERRA 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fh_u = addfile("reanalysis_clean/merra2.monthly.U.nc", "r");
fh_v = addfile("reanalysis_clean/merra2.monthly.V.nc", "r");

u = fh_u->U;
v = fh_v->V;

vor = uv2vr_cfd(u, v, fh_u->latitude, fh_u->longitude, 3);
div = uv2dv_cfd(u, v, fh_u->latitude, fh_u->longitude, 3);

printVarSummary(vor);
printVarSummary(div);

vor!0 = "time";
vor!1 = "level";
vor!2 = "latitude";
vor!3 = "longitude";
vor&time = u&time
vor&level = u&level
vor&latitude = u&latitude
vor&longitude = u&longitude
vor@long_name = "Relative Vorticity"
vor@units = "s-1"

div!0 = "time";
div!1 = "level";
div!2 = "latitude";
div!3 = "longitude";
div&time = u&time
div&level = u&level
div&latitude = u&latitude
div&longitude = u&longitude
div@long_name = "Horizontal Divergence"
div@units = "s-1"


fh_vor = addfile("reanalysis_clean/merra2.monthly.VORTICITY.nc" ,"c");
fh_div = addfile("reanalysis_clean/merra2.monthly.DIVERGENCE.nc" ,"c");

fAtt               = True            ; assign file attributes
fAtt@Dataset       = "merra2"
fAtt@Conventions   = "CF-1.0"
fAtt@creation_date = systemfunc ("date")
fileattdef( fh_vor, fAtt )            ; copy file attributes
fileattdef( fh_div, fAtt )            ; copy file attributes

fh_vor->VORTICITY = vor
fh_div->DIVERGENCE = div

delete([/u, v, fh_vor, fh_div, vor, div/])

;;;;;;;;;;; CFSR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fh_u = addfile("reanalysis_clean/cfsr.monthly.U.nc", "r");
fh_v = addfile("reanalysis_clean/cfsr.monthly.V.nc", "r");

u = fh_u->U;
v = fh_v->V;

vor = uv2vr_cfd(u, v, fh_u->latitude, fh_u->longitude, 3);
div = uv2dv_cfd(u, v, fh_u->latitude, fh_u->longitude, 3);

printVarSummary(vor);
printVarSummary(div);

vor!0 = "time";
vor!1 = "level";
vor!2 = "latitude";
vor!3 = "longitude";
vor&time = u&time
vor&level = u&level
vor&latitude = u&latitude
vor&longitude = u&longitude
vor@long_name = "Relative Vorticity"
vor@units = "s-1"

div!0 = "time";
div!1 = "level";
div!2 = "latitude";
div!3 = "longitude";
div&time = u&time
div&level = u&level
div&latitude = u&latitude
div&longitude = u&longitude
div@long_name = "Horizontal Divergence"
div@units = "s-1"


fh_vor = addfile("reanalysis_clean/cfsr.monthly.VORTICITY.nc" ,"c");
fh_div = addfile("reanalysis_clean/cfsr.monthly.DIVERGENCE.nc" ,"c");

fAtt               = True            ; assign file attributes
fAtt@Dataset       = "cfsr"
fAtt@Conventions   = "CF-1.0"
fAtt@creation_date = systemfunc ("date")
fileattdef( fh_vor, fAtt )            ; copy file attributes
fileattdef( fh_div, fAtt )            ; copy file attributes

fh_vor->VORTICITY = vor
fh_div->DIVERGENCE = div

delete([/u, v, fh_vor, fh_div, vor, div/])

;;;;;;;;;;; ERA-Interim ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fh_u = addfile("reanalysis_clean/erai.monthly.U.nc", "r");
fh_v = addfile("reanalysis_clean/erai.monthly.V.nc", "r");

u = fh_u->U;
v = fh_v->V;

vor = uv2vr_cfd(u, v, fh_u->latitude, fh_u->longitude, 3);
div = uv2dv_cfd(u, v, fh_u->latitude, fh_u->longitude, 3);

printVarSummary(vor);
printVarSummary(div);

vor!0 = "time";
vor!1 = "level";
vor!2 = "latitude";
vor!3 = "longitude";
vor&time = u&time
vor&level = u&level
vor&latitude = u&latitude
vor&longitude = u&longitude
vor@long_name = "Relative Vorticity"
vor@units = "s-1"

div!0 = "time";
div!1 = "level";
div!2 = "latitude";
div!3 = "longitude";
div&time = u&time
div&level = u&level
div&latitude = u&latitude
div&longitude = u&longitude
div@long_name = "Horizontal Divergence"
div@units = "s-1"


fh_vor = addfile("reanalysis_clean/erai.monthly.VORTICITY.nc" ,"c");
fh_div = addfile("reanalysis_clean/erai.monthly.DIVERGENCE.nc" ,"c");

fAtt               = True            ; assign file attributes
fAtt@Dataset       = "erai"
fAtt@Conventions   = "CF-1.0"
fAtt@creation_date = systemfunc ("date")
fileattdef( fh_vor, fAtt )            ; copy file attributes
fileattdef( fh_div, fAtt )            ; copy file attributes

fh_vor->VORTICITY = vor
fh_div->DIVERGENCE = div

delete([/u, v, fh_vor, fh_div, vor, div/])
