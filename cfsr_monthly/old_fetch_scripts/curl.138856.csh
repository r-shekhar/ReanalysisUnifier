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
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1979.06Z.grb2.nc.gz -o pgbhnl.gdas.1979.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1979.18Z.grb2.nc.gz -o pgbhnl.gdas.1979.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1979.00Z.grb2.nc.gz -o pgbhnl.gdas.1979.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1979.12Z.grb2.nc.gz -o pgbhnl.gdas.1979.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1980.00Z.grb2.nc.gz -o pgbhnl.gdas.1980.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1980.06Z.grb2.nc.gz -o pgbhnl.gdas.1980.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1981.06Z.grb2.nc.gz -o pgbhnl.gdas.1981.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1980.12Z.grb2.nc.gz -o pgbhnl.gdas.1980.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1981.00Z.grb2.nc.gz -o pgbhnl.gdas.1981.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1980.18Z.grb2.nc.gz -o pgbhnl.gdas.1980.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1981.12Z.grb2.nc.gz -o pgbhnl.gdas.1981.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1981.18Z.grb2.nc.gz -o pgbhnl.gdas.1981.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1982.06Z.grb2.nc.gz -o pgbhnl.gdas.1982.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1982.12Z.grb2.nc.gz -o pgbhnl.gdas.1982.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1982.18Z.grb2.nc.gz -o pgbhnl.gdas.1982.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1983.00Z.grb2.nc.gz -o pgbhnl.gdas.1983.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1982.00Z.grb2.nc.gz -o pgbhnl.gdas.1982.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1983.06Z.grb2.nc.gz -o pgbhnl.gdas.1983.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1984.06Z.grb2.nc.gz -o pgbhnl.gdas.1984.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1984.12Z.grb2.nc.gz -o pgbhnl.gdas.1984.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1983.18Z.grb2.nc.gz -o pgbhnl.gdas.1983.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1984.00Z.grb2.nc.gz -o pgbhnl.gdas.1984.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1984.18Z.grb2.nc.gz -o pgbhnl.gdas.1984.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1983.12Z.grb2.nc.gz -o pgbhnl.gdas.1983.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1985.12Z.grb2.nc.gz -o pgbhnl.gdas.1985.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1985.00Z.grb2.nc.gz -o pgbhnl.gdas.1985.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1985.18Z.grb2.nc.gz -o pgbhnl.gdas.1985.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1986.00Z.grb2.nc.gz -o pgbhnl.gdas.1986.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1985.06Z.grb2.nc.gz -o pgbhnl.gdas.1985.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1986.06Z.grb2.nc.gz -o pgbhnl.gdas.1986.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1987.00Z.grb2.nc.gz -o pgbhnl.gdas.1987.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1986.12Z.grb2.nc.gz -o pgbhnl.gdas.1986.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1987.06Z.grb2.nc.gz -o pgbhnl.gdas.1987.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1987.12Z.grb2.nc.gz -o pgbhnl.gdas.1987.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1987.18Z.grb2.nc.gz -o pgbhnl.gdas.1987.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1986.18Z.grb2.nc.gz -o pgbhnl.gdas.1986.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1988.00Z.grb2.nc.gz -o pgbhnl.gdas.1988.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1988.12Z.grb2.nc.gz -o pgbhnl.gdas.1988.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1988.06Z.grb2.nc.gz -o pgbhnl.gdas.1988.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1988.18Z.grb2.nc.gz -o pgbhnl.gdas.1988.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1989.00Z.grb2.nc.gz -o pgbhnl.gdas.1989.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1989.06Z.grb2.nc.gz -o pgbhnl.gdas.1989.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1989.18Z.grb2.nc.gz -o pgbhnl.gdas.1989.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1990.00Z.grb2.nc.gz -o pgbhnl.gdas.1990.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1989.12Z.grb2.nc.gz -o pgbhnl.gdas.1989.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1990.06Z.grb2.nc.gz -o pgbhnl.gdas.1990.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1990.12Z.grb2.nc.gz -o pgbhnl.gdas.1990.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1990.18Z.grb2.nc.gz -o pgbhnl.gdas.1990.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1991.06Z.grb2.nc.gz -o pgbhnl.gdas.1991.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1991.12Z.grb2.nc.gz -o pgbhnl.gdas.1991.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1991.00Z.grb2.nc.gz -o pgbhnl.gdas.1991.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1992.00Z.grb2.nc.gz -o pgbhnl.gdas.1992.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1991.18Z.grb2.nc.gz -o pgbhnl.gdas.1991.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1992.06Z.grb2.nc.gz -o pgbhnl.gdas.1992.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1993.00Z.grb2.nc.gz -o pgbhnl.gdas.1993.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1992.18Z.grb2.nc.gz -o pgbhnl.gdas.1992.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1993.06Z.grb2.nc.gz -o pgbhnl.gdas.1993.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1992.12Z.grb2.nc.gz -o pgbhnl.gdas.1992.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1993.18Z.grb2.nc.gz -o pgbhnl.gdas.1993.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1993.12Z.grb2.nc.gz -o pgbhnl.gdas.1993.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1994.00Z.grb2.nc.gz -o pgbhnl.gdas.1994.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1994.12Z.grb2.nc.gz -o pgbhnl.gdas.1994.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1994.06Z.grb2.nc.gz -o pgbhnl.gdas.1994.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1994.18Z.grb2.nc.gz -o pgbhnl.gdas.1994.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1995.00Z.grb2.nc.gz -o pgbhnl.gdas.1995.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1995.06Z.grb2.nc.gz -o pgbhnl.gdas.1995.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1996.00Z.grb2.nc.gz -o pgbhnl.gdas.1996.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1995.12Z.grb2.nc.gz -o pgbhnl.gdas.1995.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1995.18Z.grb2.nc.gz -o pgbhnl.gdas.1995.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1996.06Z.grb2.nc.gz -o pgbhnl.gdas.1996.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1996.12Z.grb2.nc.gz -o pgbhnl.gdas.1996.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1996.18Z.grb2.nc.gz -o pgbhnl.gdas.1996.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1997.00Z.grb2.nc.gz -o pgbhnl.gdas.1997.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1997.12Z.grb2.nc.gz -o pgbhnl.gdas.1997.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1997.06Z.grb2.nc.gz -o pgbhnl.gdas.1997.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1997.18Z.grb2.nc.gz -o pgbhnl.gdas.1997.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1998.00Z.grb2.nc.gz -o pgbhnl.gdas.1998.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1998.06Z.grb2.nc.gz -o pgbhnl.gdas.1998.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1999.00Z.grb2.nc.gz -o pgbhnl.gdas.1999.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1998.12Z.grb2.nc.gz -o pgbhnl.gdas.1998.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1998.18Z.grb2.nc.gz -o pgbhnl.gdas.1998.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1999.06Z.grb2.nc.gz -o pgbhnl.gdas.1999.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1999.12Z.grb2.nc.gz -o pgbhnl.gdas.1999.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.1999.18Z.grb2.nc.gz -o pgbhnl.gdas.1999.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2000.00Z.grb2.nc.gz -o pgbhnl.gdas.2000.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2000.06Z.grb2.nc.gz -o pgbhnl.gdas.2000.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2000.12Z.grb2.nc.gz -o pgbhnl.gdas.2000.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2001.00Z.grb2.nc.gz -o pgbhnl.gdas.2001.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2000.18Z.grb2.nc.gz -o pgbhnl.gdas.2000.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2001.12Z.grb2.nc.gz -o pgbhnl.gdas.2001.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2001.06Z.grb2.nc.gz -o pgbhnl.gdas.2001.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2001.18Z.grb2.nc.gz -o pgbhnl.gdas.2001.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2002.00Z.grb2.nc.gz -o pgbhnl.gdas.2002.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2002.12Z.grb2.nc.gz -o pgbhnl.gdas.2002.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2002.18Z.grb2.nc.gz -o pgbhnl.gdas.2002.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2002.06Z.grb2.nc.gz -o pgbhnl.gdas.2002.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2003.00Z.grb2.nc.gz -o pgbhnl.gdas.2003.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2003.06Z.grb2.nc.gz -o pgbhnl.gdas.2003.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2003.12Z.grb2.nc.gz -o pgbhnl.gdas.2003.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2003.18Z.grb2.nc.gz -o pgbhnl.gdas.2003.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2004.00Z.grb2.nc.gz -o pgbhnl.gdas.2004.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2004.12Z.grb2.nc.gz -o pgbhnl.gdas.2004.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2004.06Z.grb2.nc.gz -o pgbhnl.gdas.2004.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2004.18Z.grb2.nc.gz -o pgbhnl.gdas.2004.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2005.00Z.grb2.nc.gz -o pgbhnl.gdas.2005.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2005.12Z.grb2.nc.gz -o pgbhnl.gdas.2005.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2005.06Z.grb2.nc.gz -o pgbhnl.gdas.2005.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2005.18Z.grb2.nc.gz -o pgbhnl.gdas.2005.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2006.06Z.grb2.nc.gz -o pgbhnl.gdas.2006.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2006.00Z.grb2.nc.gz -o pgbhnl.gdas.2006.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2006.12Z.grb2.nc.gz -o pgbhnl.gdas.2006.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2007.00Z.grb2.nc.gz -o pgbhnl.gdas.2007.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2006.18Z.grb2.nc.gz -o pgbhnl.gdas.2006.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2007.06Z.grb2.nc.gz -o pgbhnl.gdas.2007.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2007.18Z.grb2.nc.gz -o pgbhnl.gdas.2007.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1979.06Z.grb2.nc.gz -o ipvhnl.gdas.1979.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1979.00Z.grb2.nc.gz -o ipvhnl.gdas.1979.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2008.00Z.grb2.nc.gz -o pgbhnl.gdas.2008.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1979.12Z.grb2.nc.gz -o ipvhnl.gdas.1979.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1979.18Z.grb2.nc.gz -o ipvhnl.gdas.1979.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2007.12Z.grb2.nc.gz -o pgbhnl.gdas.2007.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1980.00Z.grb2.nc.gz -o ipvhnl.gdas.1980.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2008.12Z.grb2.nc.gz -o pgbhnl.gdas.2008.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2008.06Z.grb2.nc.gz -o pgbhnl.gdas.2008.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1980.06Z.grb2.nc.gz -o ipvhnl.gdas.1980.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1980.12Z.grb2.nc.gz -o ipvhnl.gdas.1980.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1980.18Z.grb2.nc.gz -o ipvhnl.gdas.1980.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1981.06Z.grb2.nc.gz -o ipvhnl.gdas.1981.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1981.00Z.grb2.nc.gz -o ipvhnl.gdas.1981.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1981.12Z.grb2.nc.gz -o ipvhnl.gdas.1981.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1982.00Z.grb2.nc.gz -o ipvhnl.gdas.1982.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1982.06Z.grb2.nc.gz -o ipvhnl.gdas.1982.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1982.12Z.grb2.nc.gz -o ipvhnl.gdas.1982.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1981.18Z.grb2.nc.gz -o ipvhnl.gdas.1981.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1983.00Z.grb2.nc.gz -o ipvhnl.gdas.1983.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1983.12Z.grb2.nc.gz -o ipvhnl.gdas.1983.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1982.18Z.grb2.nc.gz -o ipvhnl.gdas.1982.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2008.18Z.grb2.nc.gz -o pgbhnl.gdas.2008.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1983.06Z.grb2.nc.gz -o ipvhnl.gdas.1983.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1984.06Z.grb2.nc.gz -o ipvhnl.gdas.1984.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1984.12Z.grb2.nc.gz -o ipvhnl.gdas.1984.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1984.00Z.grb2.nc.gz -o ipvhnl.gdas.1984.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1984.18Z.grb2.nc.gz -o ipvhnl.gdas.1984.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1983.18Z.grb2.nc.gz -o ipvhnl.gdas.1983.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1985.12Z.grb2.nc.gz -o ipvhnl.gdas.1985.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1985.06Z.grb2.nc.gz -o ipvhnl.gdas.1985.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1985.00Z.grb2.nc.gz -o ipvhnl.gdas.1985.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1985.18Z.grb2.nc.gz -o ipvhnl.gdas.1985.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1986.00Z.grb2.nc.gz -o ipvhnl.gdas.1986.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1986.06Z.grb2.nc.gz -o ipvhnl.gdas.1986.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1986.18Z.grb2.nc.gz -o ipvhnl.gdas.1986.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1986.12Z.grb2.nc.gz -o ipvhnl.gdas.1986.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1987.06Z.grb2.nc.gz -o ipvhnl.gdas.1987.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1987.12Z.grb2.nc.gz -o ipvhnl.gdas.1987.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1987.00Z.grb2.nc.gz -o ipvhnl.gdas.1987.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1988.00Z.grb2.nc.gz -o ipvhnl.gdas.1988.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1987.18Z.grb2.nc.gz -o ipvhnl.gdas.1987.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1988.12Z.grb2.nc.gz -o ipvhnl.gdas.1988.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1988.06Z.grb2.nc.gz -o ipvhnl.gdas.1988.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1988.18Z.grb2.nc.gz -o ipvhnl.gdas.1988.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1989.00Z.grb2.nc.gz -o ipvhnl.gdas.1989.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1989.18Z.grb2.nc.gz -o ipvhnl.gdas.1989.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1989.12Z.grb2.nc.gz -o ipvhnl.gdas.1989.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1990.06Z.grb2.nc.gz -o ipvhnl.gdas.1990.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1989.06Z.grb2.nc.gz -o ipvhnl.gdas.1989.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1990.00Z.grb2.nc.gz -o ipvhnl.gdas.1990.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1991.12Z.grb2.nc.gz -o ipvhnl.gdas.1991.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1991.00Z.grb2.nc.gz -o ipvhnl.gdas.1991.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1990.12Z.grb2.nc.gz -o ipvhnl.gdas.1990.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1991.06Z.grb2.nc.gz -o ipvhnl.gdas.1991.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1990.18Z.grb2.nc.gz -o ipvhnl.gdas.1990.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1991.18Z.grb2.nc.gz -o ipvhnl.gdas.1991.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1992.00Z.grb2.nc.gz -o ipvhnl.gdas.1992.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1992.06Z.grb2.nc.gz -o ipvhnl.gdas.1992.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1992.12Z.grb2.nc.gz -o ipvhnl.gdas.1992.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1993.00Z.grb2.nc.gz -o ipvhnl.gdas.1993.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1992.18Z.grb2.nc.gz -o ipvhnl.gdas.1992.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1993.06Z.grb2.nc.gz -o ipvhnl.gdas.1993.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1993.18Z.grb2.nc.gz -o ipvhnl.gdas.1993.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1993.12Z.grb2.nc.gz -o ipvhnl.gdas.1993.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1994.00Z.grb2.nc.gz -o ipvhnl.gdas.1994.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1994.06Z.grb2.nc.gz -o ipvhnl.gdas.1994.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1994.18Z.grb2.nc.gz -o ipvhnl.gdas.1994.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1995.06Z.grb2.nc.gz -o ipvhnl.gdas.1995.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1995.18Z.grb2.nc.gz -o ipvhnl.gdas.1995.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1994.12Z.grb2.nc.gz -o ipvhnl.gdas.1994.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1995.12Z.grb2.nc.gz -o ipvhnl.gdas.1995.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1995.00Z.grb2.nc.gz -o ipvhnl.gdas.1995.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1996.00Z.grb2.nc.gz -o ipvhnl.gdas.1996.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1997.00Z.grb2.nc.gz -o ipvhnl.gdas.1997.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1996.18Z.grb2.nc.gz -o ipvhnl.gdas.1996.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1996.12Z.grb2.nc.gz -o ipvhnl.gdas.1996.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1996.06Z.grb2.nc.gz -o ipvhnl.gdas.1996.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1997.06Z.grb2.nc.gz -o ipvhnl.gdas.1997.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1997.12Z.grb2.nc.gz -o ipvhnl.gdas.1997.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1998.12Z.grb2.nc.gz -o ipvhnl.gdas.1998.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1998.00Z.grb2.nc.gz -o ipvhnl.gdas.1998.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1998.06Z.grb2.nc.gz -o ipvhnl.gdas.1998.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1997.18Z.grb2.nc.gz -o ipvhnl.gdas.1997.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1998.18Z.grb2.nc.gz -o ipvhnl.gdas.1998.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1999.00Z.grb2.nc.gz -o ipvhnl.gdas.1999.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1999.06Z.grb2.nc.gz -o ipvhnl.gdas.1999.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2000.00Z.grb2.nc.gz -o ipvhnl.gdas.2000.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1999.12Z.grb2.nc.gz -o ipvhnl.gdas.1999.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.1999.18Z.grb2.nc.gz -o ipvhnl.gdas.1999.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2000.12Z.grb2.nc.gz -o ipvhnl.gdas.2000.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2000.06Z.grb2.nc.gz -o ipvhnl.gdas.2000.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2001.00Z.grb2.nc.gz -o ipvhnl.gdas.2001.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2001.12Z.grb2.nc.gz -o ipvhnl.gdas.2001.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2000.18Z.grb2.nc.gz -o ipvhnl.gdas.2000.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2001.06Z.grb2.nc.gz -o ipvhnl.gdas.2001.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2001.18Z.grb2.nc.gz -o ipvhnl.gdas.2001.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2002.06Z.grb2.nc.gz -o ipvhnl.gdas.2002.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2002.12Z.grb2.nc.gz -o ipvhnl.gdas.2002.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2002.00Z.grb2.nc.gz -o ipvhnl.gdas.2002.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2003.00Z.grb2.nc.gz -o ipvhnl.gdas.2003.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2002.18Z.grb2.nc.gz -o ipvhnl.gdas.2002.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2003.06Z.grb2.nc.gz -o ipvhnl.gdas.2003.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2003.12Z.grb2.nc.gz -o ipvhnl.gdas.2003.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2003.18Z.grb2.nc.gz -o ipvhnl.gdas.2003.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2004.06Z.grb2.nc.gz -o ipvhnl.gdas.2004.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2004.00Z.grb2.nc.gz -o ipvhnl.gdas.2004.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2004.12Z.grb2.nc.gz -o ipvhnl.gdas.2004.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2004.18Z.grb2.nc.gz -o ipvhnl.gdas.2004.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2005.00Z.grb2.nc.gz -o ipvhnl.gdas.2005.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2005.12Z.grb2.nc.gz -o ipvhnl.gdas.2005.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2006.00Z.grb2.nc.gz -o ipvhnl.gdas.2006.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2005.18Z.grb2.nc.gz -o ipvhnl.gdas.2005.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2006.06Z.grb2.nc.gz -o ipvhnl.gdas.2006.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2005.06Z.grb2.nc.gz -o ipvhnl.gdas.2005.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2006.12Z.grb2.nc.gz -o ipvhnl.gdas.2006.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2006.18Z.grb2.nc.gz -o ipvhnl.gdas.2006.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2007.00Z.grb2.nc.gz -o ipvhnl.gdas.2007.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2007.12Z.grb2.nc.gz -o ipvhnl.gdas.2007.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2007.18Z.grb2.nc.gz -o ipvhnl.gdas.2007.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2007.06Z.grb2.nc.gz -o ipvhnl.gdas.2007.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2008.06Z.grb2.nc.gz -o ipvhnl.gdas.2008.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2008.00Z.grb2.nc.gz -o ipvhnl.gdas.2008.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2009.00Z.grb2.nc.gz -o ipvhnl.gdas.2009.00Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2009.12Z.grb2.nc.gz -o ipvhnl.gdas.2009.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2009.06Z.grb2.nc.gz -o ipvhnl.gdas.2009.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2008.18Z.grb2.nc.gz -o ipvhnl.gdas.2008.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2009.18Z.grb2.nc.gz -o pgbhnl.gdas.2009.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2009.06Z.grb2.nc.gz -o pgbhnl.gdas.2009.06Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2009.18Z.grb2.nc.gz -o ipvhnl.gdas.2009.18Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2009.12Z.grb2.nc.gz -o pgbhnl.gdas.2009.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/ipvhnl.gdas.2008.12Z.grb2.nc.gz -o ipvhnl.gdas.2008.12Z.grb2.nc.gz
curl  $opts -b auth.rda.ucar.edu.$$ http://rda.ucar.edu/dsrqst/SHEKHAR138856/pgbhnl.gdas.2009.00Z.grb2.nc.gz -o pgbhnl.gdas.2009.00Z.grb2.nc.gz
#
# clean up
rm auth.rda.ucar.edu.$$ auth_status.rda.ucar.edu
