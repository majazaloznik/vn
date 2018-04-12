###############################################################################
## CLEAN GADM VIETNAM SHAPEFILES ##############################################
###############################################################################
## preliminaries
###############################################################################
library(maptools)
library(rmapshaper)
library(dplyr)
source("code/functions/fun-maps.R")

## import data ################################################################
###############################################################################

# import map
###############################################################################
# load spatioaloygonsdataframe of all provinces - the map files are 
# downloaded by the makefile from http://biogeo.ucdavis.edu/data/gadm2.8/rds/VNM_adm1.rds
vietnam.adm1 <- readRDS("data/raw/maps/VNM_adm1.rds")


# import province info
###############################################################################
# this data/raw/maps/VNM_adm1.csv file was manually downloaded from the 
# Wikipedia article https://en.wikipedia.org/wiki/Provinces_of_Vietnam
# the first table. 
provinces <- read.csv("data/raw/maps/VNM_adm1.csv",header=TRUE, encoding = "UTF-8")

## clean data
###############################################################################
# strip off last word
provinces$name <- gsub("\\s*\\w*$", "", provinces[,1])
# except if it is Ho chi minh city amd Đăk Nông
# This is horrible code, but I don't know how else to do it..
provinces$name <- gsub("Hồ Chí Minh", "Hồ Chí Minh city", provinces$name)
provinces$name <-   gsub(provinces$name[33], vietnam.adm1@data$NAME_1[4], provinces$name)

# turn hyphens into hyphens surrounded by spaces. (they are not actual hypnes...)
provinces$name <- gsub(substr(provinces$name[31], 11,11), " - ", provinces$name)

## now merge csv to spatialpolygon df
df <- full_join(vietnam.adm1@data, provinces,c( "NAME_1" = "name")) 

sp <- as.SpatialPolygons.PolygonsList(vietnam.adm1@polygons)

vietnam.adm1.simple <- ms_simplify(sp, keep_shapes = TRUE)

vietnam.adm1.simple.df <- SpatialPolygonsDataFrame(vietnam.adm1.simple, df)
#
## save processed data
###############################################################################
saveRDS(vietnam.adm1.simple.df, "data/processed/maps/VNM_adm1.rds")

