# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import os
os.chdir('/home/ubuntu/lesson11')
print os.getcwd()

from osgeo import ogr,osr
import os

driverName = "ESRI Shapefile"
drv = ogr.GetDriverByName( driverName )
if drv is None:
    print "%s driver not available.\n" % driverName
else:
    print  "%s driver IS available.\n" % driverName

fn = "wagn_points.shp"
layername = "wageningenlayer"
ds = drv.CreateDataSource(fn)
print ds.GetRefCount()

spatialRef = osr.SpatialReference()
spatialRef.ImportFromProj4('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')

layer=ds.CreateLayer(layername, spatialRef, ogr.wkbPoint)
print(layer.GetExtent())

fl=open("point2.kml",'w')
fl.write("<Document>")

points_wag = [(5.665923,51.987252),(5.662596,51.964902)]

for i in points_wag:
    
    points= ogr.Geometry(ogr.wkbPoint)
    points.SetPoint(0,i[0],i[1])
    fl.write("<Placemark>")
    fl.write(points.ExportToKML())
    fl.write("</Placemark>")
    layerDefinition = layer.GetLayerDefn()
    feature = ogr.Feature(layerDefinition)
    feature.SetGeometry(points)
    layer.CreateFeature(feature)    
    
print "The new extent"
print layer.GetExtent()

fl.write("</Document>")
fl.close()

print "KML file export"

import subprocess
    subprocess.call(["ogr2ogr","-f", "KML", "wagn_points.kml", "wagn_points.shp"])



## add a vector layer to the QGIS interface
qgis.utils.iface.addVectorLayer(fn, layername, "ogr") 
aLayer = qgis.utils.iface.activeLayer()
print aLayer.name()


import subprocess
    subprocess.call(["ogr2ogr","-f", "GeoJSON", "-t_srs", "crs:84","wagn_points.geojson", "wagn_points.shp"])

import folium
import os
features=[]
pointsGeo=os.path.join("wagn_points.geojson")
map_points = folium.Map(location=[52,5.7],tiles='Mapbox Bright', zoom_start=6)
map_points.choropleth(geo_path=pointsGeo)
map_points.save('wagn_points.html')

ds.Destroy()