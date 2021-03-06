###############################################################################
## PLOTTING GADM VIETNAM SHAPEFILES ###########################################
###############################################################################
## preliminaries
###############################################################################
library(maptools)
source(here::here("code","functions","fun-maps.R"))
.parold <- par(no.readonly = TRUE)

## import data ################################################################
###############################################################################
vietnam.adm1 <-   readRDS(here::here("data","processed","maps","VNM_adm1.rds"))

## subset data
###############################################################################
north <- FunRegionSelect(selection = c("Northeast", "Northwest"))
varhs <- FunRegionSelect(admin = "CCA_1", selection = c(305, 205, 301, 211))

## join polygons
###############################################################################
join.vietnam <- unionSpatialPolygons(vietnam.adm1, rep(1, length(vietnam.adm1)))
join.north <- unionSpatialPolygons(north, rep(1, length(north)))


## 1. Plot North Vientam VHLSS and VAHS regions
###############################################################################
postscript(paste0(out, "/map-north01-psf.eps"), 
           horizontal = FALSE, onefile = FALSE, paper = "special",
           height = 7, width = 10)

par(mar=c(0.1,0.1,0.1,0.1))
par(fig=c(0.12,1,0,1), new =F)
plot(north) # phony plot, for limits only
ax <-par("usr")
plot(join.vietnam, xlim=ax[1:2], ylim = c(ax[3]-1,ax[4]-.5),border = "gray", lwd=2)
plot(vietnam.adm1, border = "gray", add=TRUE)
plot(north, add=TRUE)
plot(varhs, add=TRUE, col="gray", density = 10)
plot(join.north, add=TRUE, border="red")
text(coordinates(north), labels = letters[1:14])
par(fig=c(0,.22,.5,.95), new=T)
plot(join.vietnam, border = "gray", xlim=ax[1:2])
plot(join.north, add=TRUE)
polygon(x=c(102,108,108,102), y =c(20,20,24,24))
dev.off()
par(.parold)

## 1.2 Plot North Vientam VHLSS and VAHS regions - with labels. 

postscript(paste0(out, "/map-north01-lab.eps"), 
           horizontal = FALSE, onefile = FALSE, paper = "special",
           height = 7, width = 10)
par(mar=c(0.1,0.1,0.1,0.1))
par(fig=c(0.12,1,0,1), new =F)
plot(north) # phony plot, for limits only
ax <-par("usr")
plot(join.vietnam, xlim=ax[1:2], ylim = c(ax[3]-1,ax[4]-.5),border = "gray", lwd=2)
plot(vietnam.adm1, border = "gray", add=TRUE)
plot(north, add=TRUE)
plot(varhs, add=TRUE, col="gray", density = 10)
plot(join.north, add=TRUE, border="red")
text(coordinates(north), labels = north@data$VARNAME_1)
par(fig=c(0,.22,.5,.95), new=T)
plot(join.vietnam, border = "gray", xlim=ax[1:2])
plot(join.north, add=TRUE)
polygon(x=c(102,108,108,102), y =c(20,20,24,24))
dev.off()
par(.parold)

