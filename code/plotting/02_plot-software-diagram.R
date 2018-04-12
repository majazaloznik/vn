library(extrafont)
loadfonts(device = "win", quiet = TRUE)
library(diagram)
library(shape)
library(grDevices)
par(family = "Georgia")

## PLLOTTING ==================================================================

# PRELIMINARIES   
oxford <- rgb(0,33,71,maxColorValue = 255)
oxfordsh <- rgb(68,104,125,maxColorValue = 255)
old.par <- par(mar = c(0, 0, 0, 0))
rx <- 0.06
ry <- 0.04
ax <- 0.02
ay <- 0.03

# PLOT 
openplotmat()
elpos <- diagram::coordinates (c(1, 2, 1))
bentarrow(from = elpos[1, ], to = elpos[3, ], lty = 5, lcol=oxford)
bentarrow(from = elpos[2, ], to = elpos[1, ], lty = 5, path = "V",lcol=oxford)
bentarrow(from = elpos[1, ]*1.03, to = elpos[2, ]-0.02,lcol=oxford)
bentarrow(from = elpos[3, ]+ax, to = elpos[1, ]*1.03, path = "V",lcol=oxford)
straightarrow(from = elpos[3, ], to=c( elpos[3,1 ]+0.15, elpos[3, 2]),arr.pos = 1 ,lcol=oxford)
bentarrow(from = elpos[4, ], to = c(elpos[3, 1], elpos[3, 2]-0.22), lty = 5,lcol=oxford)
bentarrow(from = elpos[2, ], to = elpos[4, ], arr.pos = 0.2,lty = 5, path = "V",lcol=oxford)
bentarrow(from = elpos[4, ]-ay, to = elpos[2, ]-ax,lcol=oxford)
bentarrow(from =c(elpos[3, 1]+ax, elpos[3, 2]-0.24 + ax), to = elpos[4, ]-ay, path = "V", arr.pos = 0.22,lcol=oxford)

selfarrow(c(elpos[2,1]-0.08, elpos[2,2]),lty = 6, curve= c(0.06,0.1),lcol=oxford)
selfarrow(c(elpos[3,1], elpos[3,2]-0.02),lty = 6, path = "D", curve= c(0.05,0.1),
          arr.pos = 0.95,lcol=oxford)

textround(mid = elpos[2,], lab = "NetLogo",
          radx=rx, lcol=oxford,
          cex = 1, shadow.col = oxfordsh)
textround(mid = elpos[2,], lab = "NetLogo",
          radx=rx-0.01,lcol=oxford,
          shadow.size = 0,
          cex = 1, shadow.col = "gray")

textround(mid = elpos[3,], lab = "R",
          radx=rx,lcol=oxford,
          cex = 1, shadow.col = oxfordsh)
textround(mid = elpos[3,], lab = "R",
          radx=rx-0.01,lcol=oxford,
          shadow.size = 0,
          cex = 1, shadow.col = "antiquewhite4")
textrect(mid = elpos[1,], lab = "RNetLogo",
         radx = 0.1,rady = ry,
         lcol=oxford,
         shadow.size = 0 ,cex = 1)
textrect(mid = elpos[4,], lab = "Rserve-Extension",
         radx = 0.17,rady = ry,
         lcol=oxford,
         shadow.size = 0 ,cex = 1)
textplain(c(0.1,elpos[2,2]), lab = "ABM")
textplain(c(elpos[3,1], elpos[3,2]-0.12), lab = "BBN")
textplain(c(0.15, 0.26), lab = "Agents' states")
textplain(c(0.77,0.9), lab = "Model control")
textplain(c(0.77,0.08), lab = "Agents' decisions")
textplain(c(0.1501,0.75), lab = "Model outputs")
textplain(c( elpos[3,1 ]+0.2, elpos[3, 2]), lab = "Analysis")

par(old.par)

