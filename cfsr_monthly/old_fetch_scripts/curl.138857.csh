#! /bin/csh -f
#
# c-shell script to download selected files from <server_name> using curl
# NOTE: if you want to run under a different shell, make sure you change
#       the 'set' commands according to your shell's syntax
# after you save the file, don't forget to make it executable
#   i.e. - "chmod 755 <name_of_script>"
#
# you can add cURL options here (progress bars, etc.)
set opts = ""
#
# Replace "xxxxxx" with your password
# IMPORTANT NOTE:  If your password uses a special character that has special meaning
#                  to csh, you should escape it with a backslash
#                  Example:  set passwd = "my\!password"
set passwd = 'xxxxxx'
set num_chars = `echo "$passwd" |awk '{print length($0)}'`
@ num = 1
set newpass = ""
while ($num <= $num_chars)
  set c = `echo "$passwd" |cut -b{$num}-{$num}`
  if ("$c" == "&") then
    set c = "%26";
  else
    if ("$c" == "?") then
      set c = "%3F"
    else
      if ("$c" == "=") then
        set c = "%3D"
      endif
    endif
  endif
  set newpass = "$newpass$c"
  @ num ++
end
set passwd = "$newpass"
#
if ("$passwd" == "xxxxxx") then
  echo "You need to set your password before you can continue"
  echo "  see the documentation in the script"
  exit
endif
#
# authenticate - NOTE: You should only execute this command ONE TIME.
# Executing this command for every data file you download may cause
# your download privileges to be suspended.
curl -o auth_status.rda.ucar.edu -k -s -c auth.rda.ucar.edu.$$ -d "email=ravi.shekhar@yale.edu&passwd=$passwd&action=login" https://rda.ucar.edu/cgi-bin/login
#
# download the file(s)
# NOTE:  if you get 403 Forbidden errors when downloading the data files, check
#        the contents of the file 'auth_status.rda.ucar.edu'
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201104.grb2.nc.gz -o pgbh.gdas.201104.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201105.grb2.nc.gz -o pgbh.gdas.201105.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201106.grb2.nc.gz -o pgbh.gdas.201106.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201102.grb2.nc.gz -o pgbh.gdas.201102.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201101.grb2.nc.gz -o pgbh.gdas.201101.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201103.grb2.nc.gz -o pgbh.gdas.201103.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201108.grb2.nc.gz -o pgbh.gdas.201108.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201109.grb2.nc.gz -o pgbh.gdas.201109.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201111.grb2.nc.gz -o pgbh.gdas.201111.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201110.grb2.nc.gz -o pgbh.gdas.201110.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201112.grb2.nc.gz -o pgbh.gdas.201112.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201107.grb2.nc.gz -o pgbh.gdas.201107.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201203.grb2.nc.gz -o pgbh.gdas.201203.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201205.grb2.nc.gz -o pgbh.gdas.201205.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201201.grb2.nc.gz -o pgbh.gdas.201201.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201204.grb2.nc.gz -o pgbh.gdas.201204.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201207.grb2.nc.gz -o pgbh.gdas.201207.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201202.grb2.nc.gz -o pgbh.gdas.201202.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201206.grb2.nc.gz -o pgbh.gdas.201206.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201209.grb2.nc.gz -o pgbh.gdas.201209.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201208.grb2.nc.gz -o pgbh.gdas.201208.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201211.grb2.nc.gz -o pgbh.gdas.201211.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201212.grb2.nc.gz -o pgbh.gdas.201212.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201210.grb2.nc.gz -o pgbh.gdas.201210.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201303.grb2.nc.gz -o pgbh.gdas.201303.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201301.grb2.nc.gz -o pgbh.gdas.201301.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201304.grb2.nc.gz -o pgbh.gdas.201304.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201302.grb2.nc.gz -o pgbh.gdas.201302.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201306.grb2.nc.gz -o pgbh.gdas.201306.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201305.grb2.nc.gz -o pgbh.gdas.201305.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201309.grb2.nc.gz -o pgbh.gdas.201309.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201308.grb2.nc.gz -o pgbh.gdas.201308.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201307.grb2.nc.gz -o pgbh.gdas.201307.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201310.grb2.nc.gz -o pgbh.gdas.201310.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201401.grb2.nc.gz -o pgbh.gdas.201401.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201402.grb2.nc.gz -o pgbh.gdas.201402.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201403.grb2.nc.gz -o pgbh.gdas.201403.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201404.grb2.nc.gz -o pgbh.gdas.201404.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201312.grb2.nc.gz -o pgbh.gdas.201312.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201311.grb2.nc.gz -o pgbh.gdas.201311.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201407.grb2.nc.gz -o pgbh.gdas.201407.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201405.grb2.nc.gz -o pgbh.gdas.201405.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201408.grb2.nc.gz -o pgbh.gdas.201408.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201406.grb2.nc.gz -o pgbh.gdas.201406.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201410.grb2.nc.gz -o pgbh.gdas.201410.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201411.grb2.nc.gz -o pgbh.gdas.201411.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201409.grb2.nc.gz -o pgbh.gdas.201409.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201501.grb2.nc.gz -o pgbh.gdas.201501.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201101.grb2.nc.gz -o ipvh.gdas.201101.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201102.grb2.nc.gz -o ipvh.gdas.201102.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201103.grb2.nc.gz -o ipvh.gdas.201103.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201104.grb2.nc.gz -o ipvh.gdas.201104.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201105.grb2.nc.gz -o ipvh.gdas.201105.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201106.grb2.nc.gz -o ipvh.gdas.201106.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201503.grb2.nc.gz -o pgbh.gdas.201503.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201107.grb2.nc.gz -o ipvh.gdas.201107.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201108.grb2.nc.gz -o ipvh.gdas.201108.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201109.grb2.nc.gz -o ipvh.gdas.201109.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201412.grb2.nc.gz -o pgbh.gdas.201412.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201110.grb2.nc.gz -o ipvh.gdas.201110.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201111.grb2.nc.gz -o ipvh.gdas.201111.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201112.grb2.nc.gz -o ipvh.gdas.201112.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201202.grb2.nc.gz -o ipvh.gdas.201202.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201201.grb2.nc.gz -o ipvh.gdas.201201.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201204.grb2.nc.gz -o ipvh.gdas.201204.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201203.grb2.nc.gz -o ipvh.gdas.201203.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201205.grb2.nc.gz -o ipvh.gdas.201205.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201206.grb2.nc.gz -o ipvh.gdas.201206.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201210.grb2.nc.gz -o ipvh.gdas.201210.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201502.grb2.nc.gz -o pgbh.gdas.201502.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201208.grb2.nc.gz -o ipvh.gdas.201208.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201209.grb2.nc.gz -o ipvh.gdas.201209.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201207.grb2.nc.gz -o ipvh.gdas.201207.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201211.grb2.nc.gz -o ipvh.gdas.201211.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201212.grb2.nc.gz -o ipvh.gdas.201212.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201504.grb2.nc.gz -o pgbh.gdas.201504.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201301.grb2.nc.gz -o ipvh.gdas.201301.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201303.grb2.nc.gz -o ipvh.gdas.201303.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201305.grb2.nc.gz -o ipvh.gdas.201305.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201304.grb2.nc.gz -o ipvh.gdas.201304.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201306.grb2.nc.gz -o ipvh.gdas.201306.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201307.grb2.nc.gz -o ipvh.gdas.201307.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201310.grb2.nc.gz -o ipvh.gdas.201310.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201311.grb2.nc.gz -o ipvh.gdas.201311.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201309.grb2.nc.gz -o ipvh.gdas.201309.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201302.grb2.nc.gz -o ipvh.gdas.201302.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201308.grb2.nc.gz -o ipvh.gdas.201308.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201312.grb2.nc.gz -o ipvh.gdas.201312.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201403.grb2.nc.gz -o ipvh.gdas.201403.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201401.grb2.nc.gz -o ipvh.gdas.201401.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201406.grb2.nc.gz -o ipvh.gdas.201406.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201402.grb2.nc.gz -o ipvh.gdas.201402.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201404.grb2.nc.gz -o ipvh.gdas.201404.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201405.grb2.nc.gz -o ipvh.gdas.201405.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201407.grb2.nc.gz -o ipvh.gdas.201407.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201408.grb2.nc.gz -o ipvh.gdas.201408.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201410.grb2.nc.gz -o ipvh.gdas.201410.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201409.grb2.nc.gz -o ipvh.gdas.201409.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201502.grb2.nc.gz -o ipvh.gdas.201502.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201505.grb2.nc.gz -o pgbh.gdas.201505.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201411.grb2.nc.gz -o ipvh.gdas.201411.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201503.grb2.nc.gz -o ipvh.gdas.201503.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201501.grb2.nc.gz -o ipvh.gdas.201501.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201412.grb2.nc.gz -o ipvh.gdas.201412.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201509.grb2.nc.gz -o ipvh.gdas.201509.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201506.grb2.nc.gz -o ipvh.gdas.201506.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201504.grb2.nc.gz -o ipvh.gdas.201504.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201505.grb2.nc.gz -o ipvh.gdas.201505.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201507.grb2.nc.gz -o ipvh.gdas.201507.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201506.grb2.nc.gz -o pgbh.gdas.201506.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/ipvh.gdas.201508.grb2.nc.gz -o ipvh.gdas.201508.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201507.grb2.nc.gz -o pgbh.gdas.201507.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201509.grb2.nc.gz -o pgbh.gdas.201509.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138857/pgbh.gdas.201508.grb2.nc.gz -o pgbh.gdas.201508.grb2.nc.gz
#
# clean up
rm auth.rda.ucar.edu.$$ auth_status.rda.ucar.edu
