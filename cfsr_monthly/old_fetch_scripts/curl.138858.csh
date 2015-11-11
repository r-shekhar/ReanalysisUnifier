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
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100121-20100125.grb2.nc.gz -o pgbhnl.gdas.20100121-20100125.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100116-20100120.grb2.nc.gz -o pgbhnl.gdas.20100116-20100120.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100106-20100110.grb2.nc.gz -o pgbhnl.gdas.20100106-20100110.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100101-20100105.grb2.nc.gz -o pgbhnl.gdas.20100101-20100105.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100111-20100115.grb2.nc.gz -o pgbhnl.gdas.20100111-20100115.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100126-20100131.grb2.nc.gz -o pgbhnl.gdas.20100126-20100131.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100226-20100228.grb2.nc.gz -o pgbhnl.gdas.20100226-20100228.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100201-20100205.grb2.nc.gz -o pgbhnl.gdas.20100201-20100205.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100206-20100210.grb2.nc.gz -o pgbhnl.gdas.20100206-20100210.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100211-20100215.grb2.nc.gz -o pgbhnl.gdas.20100211-20100215.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100221-20100225.grb2.nc.gz -o pgbhnl.gdas.20100221-20100225.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100216-20100220.grb2.nc.gz -o pgbhnl.gdas.20100216-20100220.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100301-20100305.grb2.nc.gz -o pgbhnl.gdas.20100301-20100305.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100316-20100320.grb2.nc.gz -o pgbhnl.gdas.20100316-20100320.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100306-20100310.grb2.nc.gz -o pgbhnl.gdas.20100306-20100310.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100311-20100315.grb2.nc.gz -o pgbhnl.gdas.20100311-20100315.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100321-20100325.grb2.nc.gz -o pgbhnl.gdas.20100321-20100325.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100326-20100331.grb2.nc.gz -o pgbhnl.gdas.20100326-20100331.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100411-20100415.grb2.nc.gz -o pgbhnl.gdas.20100411-20100415.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100406-20100410.grb2.nc.gz -o pgbhnl.gdas.20100406-20100410.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100401-20100405.grb2.nc.gz -o pgbhnl.gdas.20100401-20100405.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100416-20100420.grb2.nc.gz -o pgbhnl.gdas.20100416-20100420.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100421-20100425.grb2.nc.gz -o pgbhnl.gdas.20100421-20100425.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100426-20100430.grb2.nc.gz -o pgbhnl.gdas.20100426-20100430.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100511-20100515.grb2.nc.gz -o pgbhnl.gdas.20100511-20100515.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100501-20100505.grb2.nc.gz -o pgbhnl.gdas.20100501-20100505.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100521-20100525.grb2.nc.gz -o pgbhnl.gdas.20100521-20100525.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100516-20100520.grb2.nc.gz -o pgbhnl.gdas.20100516-20100520.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100506-20100510.grb2.nc.gz -o pgbhnl.gdas.20100506-20100510.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100526-20100531.grb2.nc.gz -o pgbhnl.gdas.20100526-20100531.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100601-20100605.grb2.nc.gz -o pgbhnl.gdas.20100601-20100605.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100606-20100610.grb2.nc.gz -o pgbhnl.gdas.20100606-20100610.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100616-20100620.grb2.nc.gz -o pgbhnl.gdas.20100616-20100620.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100611-20100615.grb2.nc.gz -o pgbhnl.gdas.20100611-20100615.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100621-20100625.grb2.nc.gz -o pgbhnl.gdas.20100621-20100625.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100626-20100630.grb2.nc.gz -o pgbhnl.gdas.20100626-20100630.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100701-20100705.grb2.nc.gz -o pgbhnl.gdas.20100701-20100705.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100706-20100710.grb2.nc.gz -o pgbhnl.gdas.20100706-20100710.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100711-20100715.grb2.nc.gz -o pgbhnl.gdas.20100711-20100715.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100716-20100720.grb2.nc.gz -o pgbhnl.gdas.20100716-20100720.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100721-20100725.grb2.nc.gz -o pgbhnl.gdas.20100721-20100725.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100801-20100805.grb2.nc.gz -o pgbhnl.gdas.20100801-20100805.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100806-20100810.grb2.nc.gz -o pgbhnl.gdas.20100806-20100810.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100811-20100815.grb2.nc.gz -o pgbhnl.gdas.20100811-20100815.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100816-20100820.grb2.nc.gz -o pgbhnl.gdas.20100816-20100820.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100821-20100825.grb2.nc.gz -o pgbhnl.gdas.20100821-20100825.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100726-20100731.grb2.nc.gz -o pgbhnl.gdas.20100726-20100731.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100901-20100905.grb2.nc.gz -o pgbhnl.gdas.20100901-20100905.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100911-20100915.grb2.nc.gz -o pgbhnl.gdas.20100911-20100915.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100916-20100920.grb2.nc.gz -o pgbhnl.gdas.20100916-20100920.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100906-20100910.grb2.nc.gz -o pgbhnl.gdas.20100906-20100910.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100921-20100925.grb2.nc.gz -o pgbhnl.gdas.20100921-20100925.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100826-20100831.grb2.nc.gz -o pgbhnl.gdas.20100826-20100831.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101001-20101005.grb2.nc.gz -o pgbhnl.gdas.20101001-20101005.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20100926-20100930.grb2.nc.gz -o pgbhnl.gdas.20100926-20100930.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101016-20101020.grb2.nc.gz -o pgbhnl.gdas.20101016-20101020.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101006-20101010.grb2.nc.gz -o pgbhnl.gdas.20101006-20101010.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101011-20101015.grb2.nc.gz -o pgbhnl.gdas.20101011-20101015.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101021-20101025.grb2.nc.gz -o pgbhnl.gdas.20101021-20101025.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101106-20101110.grb2.nc.gz -o pgbhnl.gdas.20101106-20101110.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101111-20101115.grb2.nc.gz -o pgbhnl.gdas.20101111-20101115.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101101-20101105.grb2.nc.gz -o pgbhnl.gdas.20101101-20101105.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101116-20101120.grb2.nc.gz -o pgbhnl.gdas.20101116-20101120.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100901-20100905.grb2.nc.gz -o ipvhnl.gdas.20100901-20100905.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101121-20101125.grb2.nc.gz -o pgbhnl.gdas.20101121-20101125.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100201-20100205.grb2.nc.gz -o ipvhnl.gdas.20100201-20100205.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100101-20100105.grb2.nc.gz -o ipvhnl.gdas.20100101-20100105.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100601-20100605.grb2.nc.gz -o ipvhnl.gdas.20100601-20100605.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100301-20100305.grb2.nc.gz -o ipvhnl.gdas.20100301-20100305.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101001-20101005.grb2.nc.gz -o ipvhnl.gdas.20101001-20101005.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101101-20101105.grb2.nc.gz -o ipvhnl.gdas.20101101-20101105.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100401-20100405.grb2.nc.gz -o ipvhnl.gdas.20100401-20100405.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100701-20100705.grb2.nc.gz -o ipvhnl.gdas.20100701-20100705.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100801-20100805.grb2.nc.gz -o ipvhnl.gdas.20100801-20100805.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101201-20101205.grb2.nc.gz -o ipvhnl.gdas.20101201-20101205.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101026-20101031.grb2.nc.gz -o pgbhnl.gdas.20101026-20101031.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100501-20100505.grb2.nc.gz -o ipvhnl.gdas.20100501-20100505.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100906-20100910.grb2.nc.gz -o ipvhnl.gdas.20100906-20100910.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100606-20100610.grb2.nc.gz -o ipvhnl.gdas.20100606-20100610.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100306-20100310.grb2.nc.gz -o ipvhnl.gdas.20100306-20100310.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100106-20100110.grb2.nc.gz -o ipvhnl.gdas.20100106-20100110.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100206-20100210.grb2.nc.gz -o ipvhnl.gdas.20100206-20100210.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100706-20100710.grb2.nc.gz -o ipvhnl.gdas.20100706-20100710.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101006-20101010.grb2.nc.gz -o ipvhnl.gdas.20101006-20101010.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100806-20100810.grb2.nc.gz -o ipvhnl.gdas.20100806-20100810.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101126-20101130.grb2.nc.gz -o pgbhnl.gdas.20101126-20101130.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100406-20100410.grb2.nc.gz -o ipvhnl.gdas.20100406-20100410.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100506-20100510.grb2.nc.gz -o ipvhnl.gdas.20100506-20100510.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101206-20101210.grb2.nc.gz -o ipvhnl.gdas.20101206-20101210.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101106-20101110.grb2.nc.gz -o ipvhnl.gdas.20101106-20101110.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100311-20100315.grb2.nc.gz -o ipvhnl.gdas.20100311-20100315.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100611-20100615.grb2.nc.gz -o ipvhnl.gdas.20100611-20100615.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100211-20100215.grb2.nc.gz -o ipvhnl.gdas.20100211-20100215.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100411-20100415.grb2.nc.gz -o ipvhnl.gdas.20100411-20100415.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100911-20100915.grb2.nc.gz -o ipvhnl.gdas.20100911-20100915.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100111-20100115.grb2.nc.gz -o ipvhnl.gdas.20100111-20100115.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101206-20101210.grb2.nc.gz -o pgbhnl.gdas.20101206-20101210.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101111-20101115.grb2.nc.gz -o ipvhnl.gdas.20101111-20101115.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101211-20101215.grb2.nc.gz -o ipvhnl.gdas.20101211-20101215.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100711-20100715.grb2.nc.gz -o ipvhnl.gdas.20100711-20100715.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100811-20100815.grb2.nc.gz -o ipvhnl.gdas.20100811-20100815.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100511-20100515.grb2.nc.gz -o ipvhnl.gdas.20100511-20100515.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101011-20101015.grb2.nc.gz -o ipvhnl.gdas.20101011-20101015.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100616-20100620.grb2.nc.gz -o ipvhnl.gdas.20100616-20100620.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100316-20100320.grb2.nc.gz -o ipvhnl.gdas.20100316-20100320.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100916-20100920.grb2.nc.gz -o ipvhnl.gdas.20100916-20100920.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100416-20100420.grb2.nc.gz -o ipvhnl.gdas.20100416-20100420.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101216-20101220.grb2.nc.gz -o ipvhnl.gdas.20101216-20101220.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100116-20100120.grb2.nc.gz -o ipvhnl.gdas.20100116-20100120.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101116-20101120.grb2.nc.gz -o ipvhnl.gdas.20101116-20101120.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100516-20100520.grb2.nc.gz -o ipvhnl.gdas.20100516-20100520.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100716-20100720.grb2.nc.gz -o ipvhnl.gdas.20100716-20100720.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101016-20101020.grb2.nc.gz -o ipvhnl.gdas.20101016-20101020.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100816-20100820.grb2.nc.gz -o ipvhnl.gdas.20100816-20100820.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100621-20100625.grb2.nc.gz -o ipvhnl.gdas.20100621-20100625.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100216-20100220.grb2.nc.gz -o ipvhnl.gdas.20100216-20100220.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101121-20101125.grb2.nc.gz -o ipvhnl.gdas.20101121-20101125.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100321-20100325.grb2.nc.gz -o ipvhnl.gdas.20100321-20100325.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100921-20100925.grb2.nc.gz -o ipvhnl.gdas.20100921-20100925.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100421-20100425.grb2.nc.gz -o ipvhnl.gdas.20100421-20100425.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100721-20100725.grb2.nc.gz -o ipvhnl.gdas.20100721-20100725.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101021-20101025.grb2.nc.gz -o ipvhnl.gdas.20101021-20101025.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100821-20100825.grb2.nc.gz -o ipvhnl.gdas.20100821-20100825.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100521-20100525.grb2.nc.gz -o ipvhnl.gdas.20100521-20100525.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101221-20101225.grb2.nc.gz -o ipvhnl.gdas.20101221-20101225.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100121-20100125.grb2.nc.gz -o ipvhnl.gdas.20100121-20100125.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100221-20100225.grb2.nc.gz -o ipvhnl.gdas.20100221-20100225.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100626-20100630.grb2.nc.gz -o ipvhnl.gdas.20100626-20100630.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100926-20100930.grb2.nc.gz -o ipvhnl.gdas.20100926-20100930.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100326-20100331.grb2.nc.gz -o ipvhnl.gdas.20100326-20100331.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100426-20100430.grb2.nc.gz -o ipvhnl.gdas.20100426-20100430.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101026-20101031.grb2.nc.gz -o ipvhnl.gdas.20101026-20101031.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100226-20100228.grb2.nc.gz -o ipvhnl.gdas.20100226-20100228.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100826-20100831.grb2.nc.gz -o ipvhnl.gdas.20100826-20100831.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101126-20101130.grb2.nc.gz -o ipvhnl.gdas.20101126-20101130.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100726-20100731.grb2.nc.gz -o ipvhnl.gdas.20100726-20100731.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100526-20100531.grb2.nc.gz -o ipvhnl.gdas.20100526-20100531.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20101226-20101231.grb2.nc.gz -o ipvhnl.gdas.20101226-20101231.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101221-20101225.grb2.nc.gz -o pgbhnl.gdas.20101221-20101225.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101211-20101215.grb2.nc.gz -o pgbhnl.gdas.20101211-20101215.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101201-20101205.grb2.nc.gz -o pgbhnl.gdas.20101201-20101205.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/ipvhnl.gdas.20100126-20100131.grb2.nc.gz -o ipvhnl.gdas.20100126-20100131.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101226-20101231.grb2.nc.gz -o pgbhnl.gdas.20101226-20101231.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138858/pgbhnl.gdas.20101216-20101220.grb2.nc.gz -o pgbhnl.gdas.20101216-20101220.grb2.nc.gz
#
# clean up
rm auth.rda.ucar.edu.$$ auth_status.rda.ucar.edu
