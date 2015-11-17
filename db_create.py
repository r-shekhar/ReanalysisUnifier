#!/usr/bin/env python

import netCDF4
from glob import glob
import sys
import numpy as np
import pymongo
import hashlib

def get_netcdf_filenames():
    j = glob('cfsr*/*/*nc')
    # j.extend(glob('cmap*/*nc'))
    # j.extend(glob('era*/*nc'))
    # j.extend(glob('gp*/*nc'))
    # j.extend(glob('merra*/*nc'))
    # j.extend(glob('trmm*/*nc'))
    j.extend(glob('ersst*/*nc'))
    return j

def main():
    filenames = get_netcdf_filenames()
    filenames.sort()
#    filenames = filenames[::-1]

    for f in filenames:
        filedict = {}
        filedict['filename_on_disk'] = f
        fh = netCDF4.Dataset(f)
        for x in fh.ncattrs():
            v = fh.getncattr(x)
            if isinstance(v, np.float32):
                v = float(v)
            elif isinstance(v, np.float64):
                v = float(v)                    
            elif isinstance(v, np.int32):
                v = int(v)
            elif isinstance(v, np.int16):
                v = int(v)                    
            elif isinstance(v, np.int64):
                v = int(v)     
            elif isinstance(v, np.ndarray):
                v = [float(z) for z in v]
            else:
                pass
            filedict[x] = v
            # print(type(filedict[x]))

        dimdict = {}
        dimnames = []
        for x in fh.dimensions:
            dimnames.append(x)
            dimdict[x] = {}
            dim = fh.dimensions[x]
            dimdict[x]['length'] = len(dim)
            dimdict[x]['isunlimited'] = dim.isunlimited()
            # dimdict[x]['group'] = dim.group()
        filedict['dimensions'] = dimdict

        vardict = {}
        varnames = []
        for x in fh.variables:
            if ('.' in x):
                xmod = x.replace('.','|')
            else:
                xmod = x

            vardict[xmod] = {}
            varnames.append(xmod)

            var = fh.variables[x]

            for y in var.ncattrs():
                v = var.getncattr(y)
                if isinstance(v, np.float32):
                    v = float(v)
                elif isinstance(v, np.float64):
                    v = float(v)                    
                elif isinstance(v, np.int32):
                    v = int(v)
                elif isinstance(v, np.int16):
                    v = int(v)                    
                elif isinstance(v, np.int64):
                    v = int(v)     
                elif isinstance(v, np.ndarray):
                    v = [float(z) for z in v]
                else:
                    pass
                # print(type(v))
                vardict[xmod][y] = v
            vardict[xmod]['shape'] = var.shape
            vardict[xmod]['type'] = str(var.dtype)
            vardict[xmod]['dimensions'] = var.dimensions
        filetimes = netCDF4.num2date(
            fh.variables['time'][:], 
            fh.variables['time'].units)

        filedict['filetime'] = list(filetimes)
        filedict['variables'] = vardict
        filedict['varnames'] = varnames
        filedict['dimnames'] = dimnames
        filedict['_id'] = hashlib.sha512(f).hexdigest()
        # filedict['filecontent_md5'] = hashlib.md5(open(f, 'r').read()).hexdigest()

#        print(json.dumps(filedict, sort_keys=True, indent='    '))
        print(filedict)

        client = pymongo.MongoClient()
        db = client.rawdata
        collection = db.netcdf
        
        collection.insert_one(filedict)

        sys.stderr.write('Completed {0}\n'.format(f))

    return

if __name__ == '__main__':
    main()
