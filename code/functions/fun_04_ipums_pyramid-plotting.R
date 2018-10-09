#####==========================================================================
## gets sourced from 01-DataAnalysis.Rnw  ##
#######################################
# FunMakeTransparent
# FunPyramidPlot
# FunPyramidPlotNoAxes
# FunEduPyramid
# FunEduPyramidProp
# FunLitPyramid 
# FunLitPyramidProp


#####==========================================================================
FunMakeTransparent <- function(some.colour, alpha=100){
  new.colour <- col2rgb(some.colour)
  apply(new.colour, 2, function(cur.col.data) {rgb(red=cur.col.data[1], 
                                                   green = cur.col.data[2], 
                                                   blue=cur.col.data[3], 
                                                   alpha=alpha, 
                                                   maxColorValue=255)})
}



FunPyramidPlot <- function (lx, rx, labels = NA, top.labels = c("Male", "Age", 
                                                                "Female"), main = "", laxlab = NULL, raxlab = NULL, unit = "%", 
                            lxcol, rxcol, gap = 1, space = 0.2, ppmar = c(4, 2, 4, 2), 
                            labelcex = 1, add = FALSE, xlim, show.values = FALSE, ndig = 1, 
                            do.first = NULL) 
{
  if (any(c(lx, rx) < 0, na.rm = TRUE)) 
    stop("Negative quantities not allowed")
  lxdim <- dim(lx)
  rxdim <- dim(rx)
  ncats <- ifelse(!is.null(lxdim), dim(lx)[1], length(lx))
  if (length(labels) == 1) 
    labels <- 1:ncats
  ldim <- length(dim(labels))
  nlabels <- ifelse(ldim, length(labels[, 1]), length(labels))
  if (nlabels != ncats) 
    stop("lx and labels must all be the same length")
  if (missing(xlim)) 
    xlim <- rep(ifelse(!is.null(lxdim), ceiling(max(c(rowSums(lx), 
                                                      rowSums(rx)), na.rm = TRUE)), ceiling(max(c(lx, rx), 
                                                                                                na.rm = TRUE))), 2)
  if (!is.null(laxlab) && xlim[1] < max(laxlab)) 
    xlim[1] <- max(laxlab)
  if (!is.null(raxlab) && xlim[2] < max(raxlab)) 
    xlim[2] <- max(raxlab)
  oldmar <- par("mar")
  if (!add) {
    par(mar = ppmar, cex.axis = labelcex)
    plot(0, xlim = c(-(xlim[1] + gap), xlim[2] + gap), ylim = c(0, 
                                                                ncats + 1), type = "n", axes = FALSE, xlab = "", 
         ylab = ylab, xaxs = "i", yaxs = "i", main = main)
    if (!is.null(do.first)) 
      eval(parse(text = do.first))
    if (is.null(laxlab)) {
      laxlab <- seq(xlim[1] - gap, 0, by = -1)
      axis(1, at = -xlim[1]:-gap, labels = laxlab)
    }    else axis(1, at = -(laxlab + gap), labels = laxlab)
    if (is.null(raxlab)) {
      raxlab <- 0:(xlim[2] - gap)
      axis(1, at = gap:xlim[2], labels = raxlab)
    }    else axis(1, at = raxlab + gap, labels = raxlab)
    if (gap > 0) {
      if (!is.null(lxdim)) 
        axis(2, at = 1:ncats, labels = rep("", ncats), 
             pos = gap, tcl = -0.25)
      else axis(2, at = 1:ncats * as.logical(rx + 1), labels = rep("", 
                                                                   ncats), pos = gap, tcl = -0.25)
      if (!is.null(lxdim)) 
        axis(4, at = 1:ncats, labels = rep("", ncats), 
             pos = -gap, tcl = -0.25)
      else axis(4, at = 1:ncats * as.logical(lx + 1), labels = rep("", 
                                                                   ncats), pos = gap, tcl = -0.25)
    }
    if (is.null(dim(labels))) {
      if (gap) 
        text(0, 1:ncats, labels, cex = labelcex)
      else {
        text(xlim[1], 1:ncats, labels, cex = labelcex, 
             adj = 0)
        text(xlim[2], 1:ncats, labels, cex = labelcex, 
             adj = 1)
      }
    }
    else {
      if (gap) {
        lpos <- -gap
        rpos <- gap
      }
      else {
        lpos <- -xlim[1]
        rpos <- xlim[2]
      }
      text(lpos, 1:ncats, labels[, 1], pos = 4, cex = labelcex, 
           adj = 0)
      text(rpos, 1:ncats, labels[, 2], pos = 2, cex = labelcex, 
           adj = 1)
    }
    mtext(top.labels, 3, 0, at = c(-xlim[1]/2, 0, xlim[2]/2), 
          adj = 0.5, cex = labelcex)
    mtext(c(unit, unit), 1, 2, at = c(-xlim[1]/2, xlim[2]/2))
  }
  halfwidth <- 0.5 - space/2
  if (is.null(lxdim)) {
    if (missing(lxcol)) 
      lxcol <- rainbow(ncats)
    if (missing(rxcol)) 
      rxcol <- rainbow(ncats)
    rect(-(lx + gap), 1:ncats - halfwidth, rep(-gap, ncats), 
         1:ncats + halfwidth, col = lxcol, border=lxcol)
    rect(rep(gap, ncats), 1:ncats - halfwidth, (rx + gap), 
         1:ncats + halfwidth, col = rxcol, border=rxcol)
    if (show.values) {
      par(xpd = TRUE)
      text(-(gap + lx), 1:ncats, round(lx, ndig), pos = 2, 
           cex = labelcex)
      text(gap + rx, 1:ncats, round(rx, ndig), pos = 4, 
           cex = labelcex)
      par(xpd = FALSE)
    }
  }
  else {
    nstack <- dim(lx)[2]
    if (missing(lxcol)) 
      lxcol <- rainbow(nstack)
    if (missing(rxcol)) 
      rxcol <- rainbow(nstack)
    lxstart <- rxstart <- rep(gap, ncats)
    for (i in 1:nstack) {
      lxcolor <- rep(lxcol[i], ncats)
      rxcolor <- rep(rxcol[i], ncats)
      rect(-(lx[, i] + lxstart), 1:ncats - halfwidth, -lxstart, 
           1:ncats + halfwidth, col = lxcolor, border=lxcolor)
      rect(rxstart, 1:ncats - halfwidth, rx[, i] + rxstart, 
           1:ncats + halfwidth, col = rxcolor, border=rxcolor)
      lxstart <- lx[, i] + lxstart
      rxstart <- rx[, i] + rxstart
    }
  }
  return(oldmar)
}


#####==========================================================================
FunPyramidPlotNoAxes <- function (lx, rx, labels = NA, top.labels = c("Male", "Age", 
                                                                      "Female"), main = "", laxlab = NULL, raxlab = NULL, unit = "%", 
                                  lxcol, rxcol, gap = 1, space = 0.2, ppmar = c(4, 2, 4, 2), 
                                  labelcex = 1, add = FALSE, xlim, show.values = FALSE, ndig = 1, 
                                  do.first = NULL, axes=FALSE, density=NULL, angle=45, lwd = 2, border="black",
                                  ylab="") 
{
  if (axes==FALSE) show.values<- FALSE
  if (any(c(lx, rx) < 0, na.rm = TRUE)) 
    stop("Negative quantities not allowed")
  lxdim <- dim(lx)
  rxdim <- dim(rx)
  ncats <- ifelse(!is.null(lxdim), dim(lx)[1], length(lx))
  if (length(labels) == 1) 
    labels <- 1:ncats
  ldim <- length(dim(labels))
  nlabels <- ifelse(ldim, length(labels[, 1]), length(labels))
  if (nlabels != ncats) 
    stop("lx and labels must all be the same length")
  if (missing(xlim)) 
    xlim <- rep(ifelse(!is.null(lxdim), ceiling(max(c(rowSums(lx), 
                                                      rowSums(rx)), na.rm = TRUE)), ceiling(max(c(lx, rx), 
                                                                                                na.rm = TRUE))), 2)
  if (!is.null(laxlab) && xlim[1] < max(laxlab)) 
    xlim[1] <- max(laxlab)
  if (!is.null(raxlab) && xlim[2] < max(raxlab)) 
    xlim[2] <- max(raxlab)
  oldmar <- par("mar")
  if (!add) {
    par(mar = ppmar, cex.axis = labelcex)
    plot(0, xlim = c(-(xlim[1] + gap), xlim[2] + gap), ylim = c(0, 
                                                                ncats + 1), type = "n", axes = FALSE, xlab = "", 
         ylab = ylab, xaxs = "i", yaxs = "i", main = main)
    if (!is.null(do.first)) 
      eval(parse(text = do.first))
    if (is.null(laxlab)) {
      laxlab <- seq(xlim[1] - gap, 0, by = -1)
      if (axes==TRUE) axis(1, at = -xlim[1]:-gap, labels = laxlab)
    }
    else {if (axes==TRUE) axis(1, at = -(laxlab + gap), labels = laxlab)}
    if (is.null(raxlab)) {
      raxlab <- 0:(xlim[2] - gap)
      if (axes==TRUE) axis(1, at = gap:xlim[2], labels = raxlab)
    }
    else {if (axes==TRUE) axis(1, at = raxlab + gap, labels = raxlab)}
    if (gap > 0) {
      if (!is.null(lxdim)) 
        if (axes==TRUE) axis(2, at = 1:ncats, labels = rep("", ncats), 
                             pos = gap, tcl = -0.25)
      else {if (axes==TRUE) axis(2, at = 1:ncats * as.logical(rx + 1), labels = rep("", 
                                                                                    ncats), pos = gap, tcl = -0.25)}
      if (!is.null(lxdim)) 
        if (axes==TRUE) axis(4, at = 1:ncats, labels = rep("", ncats), 
                             pos = -gap, tcl = -0.25)
      else {if (axes==TRUE) axis(4, at = 1:ncats * as.logical(lx + 1), labels = rep("", 
                                                                                    ncats), pos = gap, tcl = -0.25)}
    }
    if (is.null(dim(labels)) & axes==TRUE) {
      if (gap) 
        text(0, 1:ncats, labels, cex = labelcex)
      else {
        text(xlim[1], 1:ncats, labels, cex = labelcex, 
             adj = 0)
        text(xlim[2], 1:ncats, labels, cex = labelcex, 
             adj = 1)
      }
    }
    else { if ( axes==TRUE) {
      if (gap) {
        lpos <- -gap
        rpos <- gap
      }
      else {
        lpos <- -xlim[1]
        rpos <- xlim[2]
      }
      text(lpos, 1:ncats, labels[, 1], pos = 4, cex = labelcex, 
           adj = 0)
      text(rpos, 1:ncats, labels[, 2], pos = 2, cex = labelcex, 
           adj = 1)
    }}
    mtext(top.labels, 3, 0, at = c(-xlim[1]/2, 0, xlim[2]/2), 
          adj = 0.5, cex = labelcex)
    mtext(c(unit, unit), 1, 2, at = c(-xlim[1]/2, xlim[2]/2))
  }
  halfwidth <- 0.5 - space/2
  if (is.null(lxdim)) {
    if (missing(lxcol)) 
      lxcol <- rainbow(ncats)
    if (missing(rxcol)) 
      rxcol <- rainbow(ncats)
    rect(-(lx + gap), 1:ncats - halfwidth, rep(-gap, ncats), 
         1:ncats + halfwidth, col = lxcol, density=density, angle=angle, lwd=lwd, border=border)
    rect(rep(gap, ncats), 1:ncats - halfwidth, (rx + gap), 
         1:ncats + halfwidth, col = rxcol, density=density, angle=angle, lwd=lwd, border=border)
    if (show.values) {
      par(xpd = TRUE)
      text(-(gap + lx), 1:ncats, round(lx, ndig), pos = 2, 
           cex = labelcex)
      text(gap + rx, 1:ncats, round(rx, ndig), pos = 4, 
           cex = labelcex)
      par(xpd = FALSE)
    }
  }
  else {
    nstack <- dim(lx)[2]
    if (missing(lxcol)) 
      lxcol <- rainbow(nstack)
    if (missing(rxcol)) 
      rxcol <- rainbow(nstack)
    lxstart <- rxstart <- rep(gap, ncats)
    for (i in 1:nstack) {
      lxcolor <- rep(lxcol[i], ncats)
      rxcolor <- rep(rxcol[i], ncats)
      densityfinal <- rep(density[i], ncats)
      rect(-(lx[, i] + lxstart), 1:ncats - halfwidth, -lxstart, 
           1:ncats + halfwidth, col = lxcolor, density=densityfinal, angle=angle, lwd=lwd, border=border)
      rect(rxstart, 1:ncats - halfwidth, rx[, i] + rxstart, 
           1:ncats + halfwidth, col = rxcolor, density=densityfinal, angle=angle, lwd=lwd, border=border)
      lxstart <- lx[, i] + lxstart
      rxstart <- rx[, i] + rxstart
    }
  }
  return(oldmar)
}


#####==========================================================================
FunEduPyramid <- function(y=1989){
    lx <- as.matrix(left_join(arrange(expand.grid(age.g=levels(pyramid.age.edu.$age.g)), age.g),
                              filter(pyramid.age.edu., year==y, sex==1))[,4:7])
    rx <-as.matrix(left_join(arrange(expand.grid(age.g=levels(pyramid.age.edu.$age.g)), age.g),
                           filter(pyramid.age.edu., year==y, sex==2))[,4:7])
    lx[is.na(lx)] <- 0
    rx[is.na(rx)] <- 0
    FunPyramidPlotNoAxes(lx, rx,
                laxlab=c(0, 1000000), raxlab=c(0, 500000), unit="", gap=0,
                xlim=c(max(apply(pyramid.age.edu.[,4:7], 1, function(x) sum(x,na.rm=TRUE))),
                       800000),
                #lxcol= c(cN, cP, cS, cT), rxcol= c(cN, cP, cS, cT),
                lxcol=rep(c1,4), rxcol=rep(c1,4),
                density=c(20,40,60,80),
                border="gray50",
                labels=as.character(levels(pyramid.age.edu.$age.g)), lwd=1 ,
                top.labels = c("", "",
                               ""),
                ppmar = c(3, 4, 1, 3))
}

#####==========================================================================
FunEduPyramidProp <- function(y=1989){
  lx <- as.matrix(left_join(arrange(expand.grid(age.g=levels(pyramid.age.edu.prop$age.g)), age.g),
                            filter(pyramid.age.edu.prop, year==y, sex==1))[,4:7])
  rx <-as.matrix(left_join(arrange(expand.grid(age.g=levels(pyramid.age.edu.prop$age.g)), age.g),
                           filter(pyramid.age.edu.prop, year==y, sex==2))[,4:7])
  lx[is.na(lx)] <- 0
  rx[is.na(rx)] <- 0
  FunPyramidPlotNoAxes(lx, rx, unit="", gap=0,
               lxcol=rep(c1,4), rxcol=rep(c1,4),
               density=c(20,40,60,80),
               border="gray50", lwd=1,
               top.labels = c("", "",
                              ""),
               ppmar = c(3, 2, 1, 3), xlim = c(1,1))
}

#####==========================================================================

FunLitPyramid <- function(y=1989){
  lx <- as.matrix(left_join(arrange(expand.grid(age.g=levels(pyramid.age.lit$age.g)), age.g),
                            filter(pyramid.age.lit, year==y, sex==1))[,4:5])
  rx <-as.matrix(left_join(arrange(expand.grid(age.g=levels(pyramid.age.lit$age.g)), age.g),
                           filter(pyramid.age.lit, year==y, sex==2))[,4:5])
  lx[is.na(lx)] <- 0
  rx[is.na(rx)] <- 0
  FunPyramidPlotNoAxes(lx, rx,
               laxlab=c(0, 1000000),
               raxlab=c(0, 500000),
               unit="", gap=0,
               xlim=c(max(apply(pyramid.age.edu.[,4:7], 1, function(x) sum(x,na.rm=TRUE))),
                      800000),
               lxcol= c(cNL, cL), rxcol= c( cNL, cL),
               labels=as.character(levels(pyramid.age.lit$age.g)),
               top.labels = c("", "",
                              ""),
               ppmar = c(3, 4, 1, 3), lwd=1)

}

FunLitPyramidProp <- function(y=1989){
  lx <- as.matrix(left_join(arrange(expand.grid(age.g=levels(pyramid.age.lit.prop$age.g)), age.g),
                            filter(pyramid.age.lit.prop, year==y, sex==1))[,4:5])

  rx <-as.matrix(left_join(arrange(expand.grid(age.g=levels(pyramid.age.lit.prop$age.g)), age.g),
                           filter(pyramid.age.lit.prop, year==y, sex==2))[,4:5])
  lx[is.na(lx)] <- 0
  rx[is.na(rx)] <- 0
  FunPyramidPlotNoAxes(lx, rx, unit="", gap=0,
               lxcol= c(cNL, cL), rxcol= c( cNL, cL), lwd=1,
                              top.labels = c("", "",
                                              ""),
                              ppmar = c(3, 2, 1, 3))
}