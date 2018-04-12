# plotting IPUMS age boxplots from data imported and cleaned in /01_IPUMS_import.R
###############################################################################
## AGE boxplot graph functions 

# function
FunBoxplotsWeightedOverlayed <- function(x){
  bxp(list(stats=all.head.box.stats$stats[,x], n=rep(1,2)),
      width=all.widths[x], boxwex=1*max(all.widths[x])/max(all.widths),
      axes=FALSE, ylim=my.xlim, border=c( c1,"gray80"),
      horizontal=TRUE, whisklty = 0, staplelty = 0)
  bxp(list(stats=agri.box.stats$stats[,x], n=rep(1,2)), add=TRUE,
      width=agri.widths[x], boxwex=sum(agri.widths[x])/ sum(all.widths[x]),
      axes=FALSE, ylim=my.xlim, boxfill=c( c1,"gray80"),
      border=c("gray30", "gray50"),
      horizontal=TRUE)
}
# function for legend on the side
FunBoxpltoLegend <- function(){
  legend.bp <- data.frame(all = c(1,2,4.5,6,8), agri = c(1, 2.4, 4.8, 5.5, 8))
  bxp(list(stats=as.matrix(legend.bp[,1]), n=3),
      width=1, boxwex=1,
      axes=FALSE, ylim=c(-10,17), border=c( c1,"gray80"),
      whisklty = 0, staplelty = 0)
  bxp(list(stats=as.matrix(legend.bp[,2]), n=3),add=TRUE,
      width=0.5, boxwex=0.5,
      axes=FALSE, ylim=c(-10,17), boxfill=c( c1,"gray80"),
      border=c("gray30", "gray50"))
  
  lines(c(0.5,0.5, 1.5,1.5), c(0,-1, -1, 0))
  lines(c(1,1), c(-1,-1.3))
  lines(c(1,1), c(9.2,9.5))
  lines(c(0.75,0.75, 1.25,1.25), c(8,9.2, 9.2, 8))
}

