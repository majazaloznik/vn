###############################################################################
## CLEAN GADM VIETNAM SHAPEFILES ##############################################
###############################################################################
## preliminaries
###############################################################################
library(maptools)
library(dplyr)

## import data
###############################################################################
# this data/raw/maps/VNM_adm1.csv file was manually downloaded from the 
# Wikipedia article https://en.wikipedia.org/wiki/Provinces_of_Vietnam
# the first table. 
provinces <- read.csv("data/raw/maps/VNM_adm1.csv",header=TRUE, encoding = "UTF-8")

# load spatioaloygonsdataframe of all provinces - the map files are 
# downloaded by the makefile. 
vietnam.adm1 <- readRDS("data/raw/maps/VNM_adm1.rds")

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

## now merge csv to spatialpolygon
vietnam.adm1@data <- full_join(vietnam.adm1@data, provinces,c( "NAME_1" = "name")) 


plot(vietnam.adm1)
plot(vietnam.adm1[vietnam.adm1@data$Region == "Northeast",], add = TRUE, border = "red")
plot(vietnam.adm1[vietnam.adm1@data$Region == "Northwest",], add = TRUE, border = "red")



join.vn <- unionSpatialPolygons(vietnam,rep(1, length(vietnam)))
join.north <- unionSpatialPolygons(north,rep(1, length(north)))

######################
#plotting
######################
# funciton for regular plot, full page, room for legend on left
# then use north for the coordinates of individual provinces to 
# add graphs
FunVNMap <- function(legend = FALSE) {
  par(mar=c(0.1,0.1,0.1,0.1))
  if (legend == TRUE) {par(fig=c(0.12,1,0,1), new =F)} else{
    par(fig=c(0.0,1,0,1), new =F)}
  plot(north)
  ax <-par("usr")
  plot(join.vn, xlim=ax[1:2], ylim = c(ax[3]-1,ax[4]),border = "gray", lwd=2)
  plot(vietnam, xlim=ax[1:2], ylim = ax[3:4],border = "gray", add=TRUE)
  plot(north, add=TRUE)
  plot(join.north, add=TRUE, border="red")
}
# to colour individual plot use e.g
# plot(north[1,], col="red", add=TRUE)

## plot number one, just labels
# par(mar=c(0.1,0.1,0.1,0.1))
# par(fig=c(0.12,1,0,1), new =F)
# plot(north)
# ax <-par("usr")
# plot(join.vn, xlim=ax[1:2], ylim = c(ax[3]-1,ax[4]-.5),border = "gray", lwd=2)
# plot(vietnam,border = "gray", add=TRUE)
# plot(north, add=TRUE)
# plot(north[14,],density=10, add=TRUE, col="gray")
# plot(north[8,],density=10, add=TRUE, col="gray")
# plot(north[7,],density=10, add=TRUE, col="gray")
# plot(north[6,],density=10, add=TRUE, col="gray")
# plot(join.north, add=TRUE, border="red")
# text(coordinates(north), labels = letters[1:14])
# par(fig=c(0,.22,.5,.95), new=T)
# plot(join.vn, border = "gray", xlim=ax[1:2])
# plot(join.north, add=TRUE)
# polygon(x=c(102,108,108,102), y =c(20,20,24,24))
# dev.copy2eps(file="Presentation/figure/map01.eps", family="ComputerModern")
par(old.par)
rm(old.par)

