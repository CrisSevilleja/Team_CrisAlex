#!/bin/bash

echo "Team:CrisAlex"

echo "12 January 2017"

echo "Calculate LandSat NDVI"

echo "Select the image"
image="./LE71700552001036SGS00_SR_Gewata_INT1U.tif"

echo "The input file: $image"
outimage="NDVI.tif"

echo "The output file: $outimage"
echo "calculate ndvi"
gdal_calc.py -A $image --A_band=4 -B $image --B_band=3 --outfile=$outimage --calc="(A.astype(float)-B)/(A.astype(float)+B)" --type='Float32'


echo "Change the resolution from 30m to 60m"

outimage2="./resampled_ndvi.tif"
gdal_translate -tr 60 60 $outimage $outimage2

echo "Reproject the image"

outimage3="reprojected_resampled_ndvi.tif"
gdalwarp -t_srs "EPSG:4326" $outimage2 $outimage3