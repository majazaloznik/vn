# VARIABLE DEFINITIONS  #######################################################
###############################################################################
# folders #####################################################################
# ALLCAPS

DIR = .

CODE = $(DIR)/code
C-DC = $(CODE)/data-cleaning
C-P = $(CODE)/plotting
C-F = $(CODE)/functions

DATA = $(DIR)/data
P-PW = $(DATA)/processed/project-wide
P-M = $(DATA)/processed/maps
R-M = $(DATA)/raw/maps

DOCS = $(DIR)/docs
J = $(DOCS)/journals

FIGS = $(DIR)/figures

# file lists ##################################################################
# lower case ##
# not using these, because they mess up the dot graph
# migration journals
# J-MIG = $(J)/j-migration.html $(J)/j-migration.pdf
# migraiton sources
# J-MIG-SRC = $(J)/j-migration.Rmd $(J)/j-appendix1.Rmd
FIG/map-north01.eps =  $(FIG)/map-north01-psf.% $(FIG)/map-north01-lab.%

# commands ####################################################################
# recipe to knit pdf from first prerequisite
KNIT-PDF = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'pdf_document' )"

# recipe to knit pdf from first prerequisite
KNIT-HTML = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'html_document' )"


# DEPENDENCIES   ##############################################################
###############################################################################
all:   $(J)/j-migration.pdf $(J)/j-migration.html  maps dot
		-rm $(wildcard ./docs/*/tex2pdf*) -fr

dot: $(FIGS)/make.png 

maps : $(FIG/map-north01.eps)


# top level dependencies ######################################################
# make file .dot
$(P-PW)/make.dot : $(DIR)/Makefile
	python $(DIR)/code/project-wide/makefile2dot.py < $< > $@

# make chart from .dot
$(FIGS)/make.png : $(P-PW)/make.dot
	Rscript -e "require(DiagrammeR); require(DiagrammeRsvg); require(rsvg); png::writePNG(rsvg(charToRaw(export_svg(grViz('$<')))), '$@')"

# journal (and its appendix) render to  html
$(J)/j-migration.html: $(J)/j-migration.Rmd $(J)/j-appendix1.Rmd $(FIGS)/make.png
	$(KNIT-HTML)

# journal (and its appendix) render to  pdf
$(J)/j-migration.pdf:  $(J)/j-migration.Rmd $(J)/j-appendix1.Rmd $(FIGS)/make.png
	$(KNIT-PDF)


# raw map data
$(R-M)/VNM_adm1.rds:
	Rscript -e "download.file('http://biogeo.ucdavis.edu/data/gadm2.8/rds/VNM_adm1.rds', 'data/raw/maps/VNM_adm1.rds', mode = 'wb')"

# processed map data	
$(P-M)/VNM_adm1.rds :	$(C-DC)/gamd-maps.R $(R-M)/VNM_adm1.rds 
	Rscript -e "source('$<')"

# two map w and w/o labels
$(FIG/map-north01.eps): $(C-P)/01-maps.R   $(P-M)/VNM_adm1.rds $(C-F)/fun-maps.R
	Rscript -e "source('$<')"
	