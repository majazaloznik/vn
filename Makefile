# VARIABLE DEFINITIONS  #######################################################
###############################################################################
# folders #####################################################################
DIR = .
DOCS = $(DIR)/docs
J = $(DOCS)/journals
FIGS = $(DIR)/figures
DATA = $(DIR)/data
P-PW = $(DATA)/processed/project-wide

# file lists ##################################################################
# migration journals
# J-MIG = $(J)/j-migration.html $(J)/j-migration.pdf
# migraiton sources
# J-MIG-SRC = $(J)/j-migration.Rmd $(J)/j-appendix1.Rmd


# commands ####################################################################
# recipe to knit pdf from first prerequisite
KNIT-PDF = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'pdf_document' )"

# recipe to knit pdf from first prerequisite
KNIT-HTML = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'html_document' )"


# DEPENDENCIES   ##############################################################
###############################################################################
all:   $(J)/j-migration.pdf $(J)/j-migration.html 
		-rm $(wildcard ./docs/*/tex2pdf*) -fr

  
# top level dependencies ######################################################
# make file .dot
$(P-PW)/make.dot : $(DIR)/Makefile
	python $(DIR)/code/functions/makefile2dot.py < $< > $@

# make chart from .dot
$(FIGS)/make.png : $(P-PW)/make.dot
	Rscript -e "require(DiagrammeR); require(DiagrammeRsvg); require(rsvg); png::writePNG(rsvg(charToRaw(export_svg(grViz('$<')))), '$@')"

# journal (and its appendix) render to  html
$(J)/j-migration.html: $(J)/j-migration.Rmd $(J)/j-appendix1.Rmd $(FIGS)/make.png
	$(KNIT-HTML)

# journal (and its appendix) render to  pdf
$(J)/j-migration.pdf:  $(J)/j-migration.Rmd $(J)/j-appendix1.Rmd $(FIGS)/make.png
	$(KNIT-PDF)

maps : 
GWF-Autocratic-Regimes-1.2.zip:
	curl -o GWF-Autocratic-Regimes-1.2.zip "http://sites.psu.edu/dictators/wp-content/uploads/sites/12570/2014/07/GWF-Autocratic-Regimes-1.2.zip"
