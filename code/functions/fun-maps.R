###############################################################################
## PLOTTING FUNCTIONS FOR  VIETNAM SHAPEFILES #################################
###############################################################################
#' 1. FunRegionSelect
###############################################################################
#' 1. FunRegionSelect
#' 
#' subsets the vietnam spatialpolygon with selected region
#' 
#' @param sp the spatialPolygon object, default is the province vientam one
#' @param admin the coloumn name from which the subset is selected, so the
#'   default is the region 
#' @param selection a vector of values of admin to select for.
#' @return spatialpolygon
FunRegionSelect <- function(sp = vietnam.adm1,
                            admin = "Region",
                            selection){
  sp[sp@data[,admin] %in% selection,]
}


                          
# ######################
# # plotting
# ######################
# # funciton for regular plot, full page, room for legend on left
# # then use north for the coordinates of individual provinces to 
# # add graphs
# FunVNMap <- function(legend = FALSE) {
#   par(mar=c(0.1,0.1,0.1,0.1))
#   if (legend == TRUE) {par(fig=c(0.12,1,0,1), new =F)} else{
#     par(fig=c(0.0,1,0,1), new =F)}
#   plot(north)
#   ax <-par("usr")
#   plot(join.vn, xlim=ax[1:2], ylim = c(ax[3]-1,ax[4]),border = "gray", lwd=2)
#   plot(vietnam, xlim=ax[1:2], ylim = ax[3:4],border = "gray", add=TRUE)
#   plot(north, add=TRUE)
#   plot(join.north, add=TRUE, border="red")
# }
# # to colour individual plot use e.g
# # plot(north[1,], col="red", add=TRUE)
# 
# ## plot number one, just labels
# # par(mar=c(0.1,0.1,0.1,0.1))
# # par(fig=c(0.12,1,0,1), new =F)
# # plot(north)
# # ax <-par("usr")
# # plot(join.vn, xlim=ax[1:2], ylim = c(ax[3]-1,ax[4]-.5),border = "gray", lwd=2)
# # plot(vietnam,border = "gray", add=TRUE)
# # plot(north, add=TRUE)
# # plot(north[14,],density=10, add=TRUE, col="gray")
# # plot(north[8,],density=10, add=TRUE, col="gray")
# # plot(north[7,],density=10, add=TRUE, col="gray")
# # plot(north[6,],density=10, add=TRUE, col="gray")
# # plot(join.north, add=TRUE, border="red")
# # text(coordinates(north), labels = letters[1:14])
# # par(fig=c(0,.22,.5,.95), new=T)
# # plot(join.vn, border = "gray", xlim=ax[1:2])
# # plot(join.north, add=TRUE)
# # polygon(x=c(102,108,108,102), y =c(20,20,24,24))
# # dev.copy2eps(file="Presentation/figure/map01.eps", family="ComputerModern")
# par(old.par)
# rm(old.par)
# 
