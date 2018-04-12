suppressWarnings(suppressMessages(require(DiagrammeR)))
suppressWarnings(suppressMessages(require(DiagrammeRsvg)))
suppressWarnings(suppressMessages(require(rsvg)))
png::writePNG(rsvg(charToRaw(export_svg(grViz("data/processed/project-wide/make.dot")))), "figures/make.png")
