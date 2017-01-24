# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
###Lesson 12 Team CrisAlex
#//24/01/2017

# import modules
import matplotlib.pyplot as plt
from os import path, system
from osgeo import gdal
from osgeo.gdalconst import GDT_Float32
import numpy as np
import tarfile
from mimetypes import guess_type
from os import mkdir, path
from urllib import urlretrieve
from zipfile import ZipFile
from osgeo.gdalconst import GA_ReadOnly, GDT_Float32
import os
import subprocess

os.chdir("lesson12")

# open file and print info about the file
# the "../" refers to the parent directory of my working directory

subprocess.call(["wget", "http://dl.dropboxusercontent.com/s/zb7nrla6fqi1mq4/LC81980242014260-SC20150123044700.tar.gz", "-O" ,"landsat.tar.gz"])


import tarfile
fileName = "landsat.tar.gz"
tfile = tarfile.open(fileName, 'r:gz')
tfile.extractall("data")


file_4 = "data/LC81980242014260LGN00_sr_band4.tif"
file_5 = "data/LC81980242014260LGN00_sr_band5.tif"


##create the NDWI

def CompNDWI (filename4, filename5):
    #open the files
    band4 = gdal.Open(filename4, GA_ReadOnly)
    band5 = gdal.Open(filename5, GA_ReadOnly)
    
    geotransform = band4.GetGeoTransform()
    geotransform = band5.GetGeoTransform()
    
    # Read data into an array
    band4Arr = band4.GetRasterBand(1).ReadAsArray(0,0,band4.RasterXSize, band4.RasterYSize)
    band5Arr = band5.GetRasterBand(1).ReadAsArray(0,0,band5.RasterXSize, band5.RasterYSize)
    
    #set the data type
    band4Arr=band4Arr.astype(np.float32)
    band5Arr=band5Arr.astype(np.float32)
    
    #Derive the NDWI
    mask = np.greater(band4Arr+band5Arr,0)

    with np.errstate(invalid='ignore') and np.errstate(divide='ignore'):
        ndwi = np.choose(mask,(-99,(band4Arr-band5Arr)/(band4Arr+band5Arr)))

    print ndwi[ndwi>-99].min()

    # Write the result to disk
    driver = gdal.GetDriverByName('GTiff')
    outDataSet=driver.Create('ndwi.tif', band4.RasterXSize, band4.RasterYSize, 1, GDT_Float32)
    outBand = outDataSet.GetRasterBand(1)
    outBand.WriteArray(ndwi,0,0)
    outBand.SetNoDataValue(-99)

    # set the projection and extent information of the dataset
    outDataSet.SetProjection(band4.GetProjection())
    outDataSet.SetGeoTransform(band4.GetGeoTransform())

    # Finally let's save it... or like in the OGR example flush it
    outBand.FlushCache()
    outDataSet.FlushCache()


CompNDWI (file_4, file_5)



##Do the projection

import subprocess

bash="gdalwarp -t_srs EPSG:4326 ndwi.tif proj_ndwi.tif"
subprocess.Popen(bash, shell = True)



# Notebook magic to select the plotting method
# Change to inline to plot within this notebook
#%matplotlib inline 
%matplotlib inline
from osgeo import gdal
import matplotlib.pyplot as plt

# Open image
dsll = gdal.Open("proj_ndwi.tif")

# Read raster data
ndwi = dsll.ReadAsArray(0, 0, dsll.RasterXSize, dsll.RasterYSize)

# Now plot the raster data using gist_earth palette
plt.imshow(ndwi, interpolation='nearest', vmin=0, cmap=plt.cm.gist_earth)
plt.show()

dsll = None


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    