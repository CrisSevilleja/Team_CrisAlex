
###Lesson 7

#17/01/2015
##Team CrisAlex: Cristina González and Wan Quanxing

library(rgdal)
library(sp)
library(raster)
library(gdalUtils)


#clean first the work directory
rm(list = ls())
srdir <- dirout <- file.path("data")
dir.create(dirout, showWarning=FALSE)

#download and descompress the file modis
download.file(url = 'https://raw.githubusercontent.com/GeoScripting-WUR/VectorRaster/gh-pages/data/MODIS.zip', destfile = 'data/modis.zip', method = 'auto')
unzip('data/modis.zip', exdir = "data")

#input the file
modis <- brick("data/MOD13A3.A2014001.h18v03.005.grd")
modis[modis < 0] <- NA
modis@data

#Prepare the raster with the average of ndvi from all months
modis_average <- mean(modis)
plot(modis_average)



#Prepare the vector
#Input data of the municipalities
nlMunicipality <- getData('GADM',country='NLD', level=2)
nlMunicipality

municipalities <- spTransform(nlMunicipality, CRS(proj4string(modis))) #project the vector

municipalities@data <- municipalities@data[!is.na(municipalities$NAME_2),] #Remove rows with NA


#Do the mask to get the raster together with the vector
modis_mask <- mask(modis, mask = municipalities)
modis_mask_year <- mask(modis_average, mask = municipalities)

#Create the data frame for January
NDVI_JAN <- extract(modis_mask[[1]], municipalities, df=TRUE, fun = mean, na.rm= TRUE)
January_mun <- cbind(NDVI_JAN, municipalities$NAME_2)
colnames(January_mun)[3] <- "Municipality"
str(January_mun)

#Create the data frame for August
NDVI_AUG <- extract(modis_mask[[8]], municipalities, df=TRUE, fun = mean, na.rm= TRUE)
August_mun <- cbind(NDVI_AUG, municipalities$NAME_2)
colnames(August_mun)[3] <- "Municipality"
str(August_mun)

#Create the data frame for over the year
NDVI_year <- extract(modis_mask_year, municipalities, df=TRUE, fun = mean, na.rm= TRUE)
year_mun <- cbind(NDVI_year, municipalities$NAME_2)
colnames(year_mun)[3] <- "Municipality"
str(year_mun)


####Join the generated data frame with the municipality vector

#For January
January <- cbind(municipalities, NDVI = January_mun$January)
names(January)
colnames(January@data)[16] <- "NDVI"

#For August
August <- cbind(municipalities, NDVI = August_mun$August)
names(August)
colnames(August@data)[16] <- "NDVI"

#For over the year
Year <- cbind(municipalities, NDVI = year_mun$layer)
names(Year)
colnames(Year@data)[16] <- "NDVI"


##Visualize all the maps in spplot

#Create the map for January
NDVI_January <- spplot(January, zcol="NDVI", main= "NDVI Netherlands in January")

#Create the map for August
NDVI_August <- spplot(August, zcol="NDVI", main= "NDVI Netherlands in August")

#Create the map for over the year
NDVI_Year <- spplot(Year, zcol="NDVI", main= "NDVI Average of Netherlands")

#Visualize the three maps for each period
NDVI_January
NDVI_August
NDVI_Year

















































