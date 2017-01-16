###Exercise lesson5

#Team CrisAlex

library(raster)
library(rgdal)
source("R/functions.R")

getwd()
setwd("/lesson5")

#first create a folder DATA to store all the generated files
srdir <- dirout <- file.path("data")
dir.create(dirout, showWarning=FALSE)

#download files in Windows
download.file("https://www.dropbox.com/s/i1ylsft80ox6a32/LC81970242014109-SC20141230042441.tar.gz?dl=1", destfile= "data/landsat8.tar.gz", method='auto')
download.file("https://www.dropbox.com/s/akb9oyye3ee92h3/LT51980241990098-SC20150107121947.tar.gz?dl=1", destfile= "data/landsat5.tar.gz", method='auto')

#download files in LINUX
download.file("https://www.dropbox.com/s/i1ylsft80ox6a32/LC81970242014109-SC20141230042441.tar.gz?dl=1", "data/landsat8.tar.gz")
download.file("https://www.dropbox.com/s/akb9oyye3ee92h3/LT51980241990098-SC20150107121947.tar.gz?dl=1", "data/landsat5.tar.gz")

#command to create a folder where descompress the files
srdir <- dirout <- file.path("data/landsat8")
dir.create(dirout, showWarning=FALSE)
srdir <- dirout <- file.path("data/landsat5")
dir.create(dirout, showWarning=FALSE)

#Descompress the files in specific folders (works good in linux)
untar("data/landsat8.tar.gz", exdir = "data/landsat8")
untar("data/landsat5.tar.gz", exdir = "data/landsat5")

#stack the files to have it togethers
l8 <- list.files(path = "data/landsat8", pattern = glob2rx('*.tif'), full.names = TRUE)
ln8 <- stack(l8)

l5 <- list.files(path = "data/landsat5", pattern = glob2rx('*.tif'), full.names = TRUE)
ln5 <- stack(l5)

#Use crop to have the same extension
ln8_ext <- intersect(ln8, ln5)
ln5_ext <- intersect(ln5, ln8)

#Create a variable with the cloud layer and other with the rest
fmask_ln8 <- ln8_ext[[1]]
ln8_drop <- dropLayer(ln8_ext, 1)
fmask_ln5 <- ln5_ext[[1]]
ln5_drop <- dropLayer(ln5_ext, 1)

ln8_drop
#apply the cloud function to remove the clouds
ln8_CloudFree <- overlay(x = ln8_drop, y = fmask_ln8, fun = cloud_rm)
ln5_CloudFree <- overlay(x = ln5_drop, y = fmask_ln5, fun = cloud_rm)

plotRGB(ln8_CloudFree, 3,5,4)

#Calculate NDVI for both rasters
ndvi_landsat5 <- ndvical(ln5_CloudFree[[5]], ln5_CloudFree[[6]])
plot(ndvi_landsat5, main = "NDVI landsat 5, 1990")
ndvi_landsat8 <- ndvical(ln8_CloudFree[[4]], ln8_CloudFree[[5]])
plot(ndvi_landsat8, main = "NDVI landsat 8, 2014")

#Differences in the NDVI between 1990 and 2014, we substract landsat5 of landsat8
NDVI_diff <- ndvi_landsat8 - ndvi_landsat5
NDVI_diff

#Determine teh range between 0 to 1.5
NDVI_diff[NDVI_diff < 0] <- 0
NDVI_diff[NDVI_diff > 1.5] <- 1.5

plot(NDVI_diff, main = "Differences in NDVI between 1990-2014")
NDVI_diff

##if the script wants to be repeated you should remove the created folders first


