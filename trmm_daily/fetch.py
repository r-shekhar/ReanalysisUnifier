#!/usr/bin/env python

import urllib
import os.path
import subprocess

#http://disc2.nascom.nasa.gov/daac-bin/OTF/HTTP_services.cgi?FILENAME=%2Fftp%2Fdata%2Fs4pa%2FTRMM_L3%2FTRMM_3B42%2F1998%2F003%2F3B42.19980103.03.7.HDF.Z&LABEL=3B42.19980103.03.7.nc&SHORTNAME=TRMM_3B42&SERVICE=HDF_TO_NetCDF&VERSION=1.02&DATASET_VERSION=007


rootpath = '/ftp/data/s4pa/TRMM_L3/TRMM_3B42/'

with open('../list_trmm.txt') as fh:
    for f in fh:
        if not(f.strip().endswith('.Z')):
            continue
        new_label = (os.path.split(f.strip())[-1])
        new_label = new_label.replace('.HDF.Z', '.nc')
        filepath = (os.path.join(rootpath, f.strip()))
        #print(urllib.quote(filepath, safe=''))
        fmtstr = 'http://disc2.nascom.nasa.gov/daac-bin/OTF/HTTP_services.cgi?FILENAME={0}&LABEL={1}&SHORTNAME=TRMM_3B42&SERVICE=HDF_TO_NetCDF&VERSION=1.02&DATASET_VERSION=007'
        fetchurl = (fmtstr.format(urllib.quote(filepath, safe=''), new_label))

        if os.path.isfile(new_label):
            print("file exists")
        else:
            try:
                #print('fetching {0}'.format(new_label))
                cmd = "/usr/bin/wget '{0}' --output-document={1}".format(fetchurl, new_label)
                print(cmd)
                j = subprocess.call(cmd, shell=True)
                print(j)
            except Exception as e:
                print(e)
        
