#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
server = ECMWFDataServer()
import os, os.path

fields_36912 = ""
fields_0 = "129.128/130.128/131.128/132.128/133.128/135.128/155.128"

for year in range(1979, 2015):
    for f in fields_0.split('/'):

        fn = "{0}.{1}.an.nc".format(year,f)
        print(fn)

        if not os.path.isfile(fn):
            server.retrieve({
                    "class": "ei",
                    "dataset": "interim",
                    "date": "{0}0101/{0}0201/{0}0301/{0}0401/{0}0501/{0}0601/{0}0701/{0}0801/{0}0901/{0}1001/{0}1101/{0}1201".format(year),
                    "grid": "0.75/0.75",
                    "levelist": "1/2/3/5/7/10/20/30/50/70/100/125/150/175/200/225/250/300/350/400/450/500/550/600/650/700/750/775/800/825/850/875/900/925/950/975/1000",
                    "levtype": "pl",
                    "param": f,
                    "step": "0",
                    "stream": "mnth",
                    "target": fn,
                    "time": "00/06/12/18",
                    "type": "an",
                    "format": "netcdf"
                    })

print("All done")
