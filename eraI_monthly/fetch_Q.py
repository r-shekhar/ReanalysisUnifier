#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
server = ECMWFDataServer()
import os, os.path

fields_36912 = "228.128/34.128/134.128/142.128/143.128/146.128/147.128/151.128/165.128/166.128/167.128/168.128/169.128/175.128/176.128/177.128/178.128/179.128/182.128/186.128/187.128/188.128/208.128/209.128/210.128/211.128/212.128/228.128/159.128"
fields_0 = "34.128/134.128/151.128/165.128/166.128/167.128/168.128/186.128/187.128/188.128/55.162/60.162/62.162/65.162/66.162/69.162/70.162/71.162/73.162/74.162/78.162/81.162/83.162/84.162/85.162/134.128/63.162/82.162/86.162/75.162/76.162"

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
                    "levtype": "sfc",
                    "param": f,
                    "step": "0",
                    "stream": "mnth",
                    "target": fn,
                    "time": "00/06/12/18",
                    "type": "an",
                    "format": "netcdf"
                    })

    for f in fields_36912.split('/'):

        fn = "{0}.{1}.fc.nc".format(year,f)
        print(fn)

        if not os.path.isfile(fn):
            server.retrieve({
                    "class": "ei",
                    "dataset": "interim",
                    "date": "{0}0101/{0}0201/{0}0301/{0}0401/{0}0501/{0}0601/{0}0701/{0}0801/{0}0901/{0}1001/{0}1101/{0}1201".format(year),
                    "grid": "0.75/0.75",
                    "levtype": "sfc",
                    "param": f,
                    "step": "3/6/9/12",
                    "stream": "mnth",
                    "target": fn,
                    "time": "00/12",
                    "type": "fc",
                    "format": "netcdf"
                    })

print("All done")
