# VARIABLE DEFINITIONS  #######################################################
###############################################################################
# folders #####################################################################
# ALLCAPS

DIR := .

CODE := $(DIR)/code
C-DC := $(CODE)/data-cleaning
C-P  := $(CODE)/plotting
C-F  := $(CODE)/functions
C-PW := $(CODE)/project-wide

DATA := $(DIR)/data
P-PW := $(DATA)/processed/project-wide
P-M := $(DATA)/processed/maps
P-I := $(DATA)/processed/ipums
R-M := $(DATA)/raw/maps

DOCS := $(DIR)/docs
J := $(DOCS)/journals
R := $(DOCS)/reports

FIG = $(DIR)/figures

# file lists ##################################################################

FIG/maps =  $(FIG)/map-north01-psf.eps #$(FIG)/map-north01-lab.eps
  

# COMMANDS ####################################################################

# recipe to make .dot file  of this makefile
define make-dot
@echo creating the .dot file from the dependencies in this makefile ----------
python $(C-PW)/makefile2dot.py < $< > $@
 sed -i 's/rankdir="BT"/rankdir="TB"/' $(P-PW)/make.dot
@echo done -------------------------------------------------------------------
endef 

# recipe to make .png file  from the dot file
define make-png
	@echo Creating the .png from the .dot ----------------------------------------
	Rscript -e "source('$<')"
	@echo done -------------------------------------------------------------------
endef

# recipe to knit pdf from first prerequisite
define knit-pdf
 @echo creating the $(@F) file by knitting it in R. ---------------------------
 Rscript -e "suppressWarnings(suppressMessages(require(rmarkdown)));\
 render('$<', output_dir = '$(@D)', output_format = 'pdf_document',\
 quiet = TRUE )"
 -rm $(wildcard ./docs/*/tex2pdf*) -fr
endef 

# recipe to knit HTML from first prerequisite
define knit-html
 @echo creating the $(@F) file by knitting it in R.---------------------------
 Rscript -e "suppressWarnings(suppressMessages(require(rmarkdown))); \
 render('$<', output_dir = '$(@D)', output_format = 'html_document',\
 quiet = TRUE )"
endef 

# recipe to knit to both doc2 and pdf2 formats from first prerequisite
define knit-all
 @echo creating the $(@F) file by knitting it in R. ---------------------------
 Rscript -e "rmarkdown::render('$<',  output_format = 'all',\
 quiet = TRUE)"
 -rm $(wildcard ./docs/*/tex2pdf*) -fr
endef 

# DEPENDENCIES   ##############################################################
###############################################################################
all:  journal  maps dot


## Journal ====================================================================
journal: $(J)/j-migration.pdf $(J)/j-migration.html 
# journal (and its appendix) render to  html
$(J)/j-migration.html: $(J)/j-migration.Rmd
	$(knit-html)

# journal (and its appendix) render to  pdf
$(J)/j-migration.pdf:  $(J)/j-migration.Rmd $(J)/j-appendix1.Rmd $(FIG)/make.png
	$(knit-pdf)



## Makefile chart =============================================================
dot: $(FIG)/make.png 
# make chart from .dot
$(FIG)/make.png: $(C-PW)/dot2png.R $(P-PW)/make.dot
	$(make-png)

# make file .dot
$(P-PW)/make.dot: $(DIR)/Makefile
	$(make-dot)


## ABM report ================================================================#
report:  $(R)/01_ABM-report.pdf $(R)/01_ABM-report.docx

# Produce whole report
$(R)/01_ABM-report.pdf: $(R)/01_ABM-report.Rmd
	$(knit-all)

# dependencies - second output
$(R)/01_ABM-report.docx: $(R)/01_ABM-report.Rmd

# dependencies - children of the main report
$(R)/01_ABM-report.Rmd: $(R)/01_ABM-report_01_Intro.Rmd $(R)/01_ABM-report_02_Outline.Rmd $(R)/01_ABM-report_03_Analysis.Rmd
	touch $(R)/01_ABM-report.Rmd

# plot software diagram in 02	
$(R)/01_ABM-report_02_Outline.Rmd: $(C-P)/02_plot-software-diagram.R
	touch $(R)/01_ABM-report_02_Outline.Rmd

# dependencies: map data, IPUMS data and age boxplot functions, retiremen table,
$(R)/01_ABM-report_03_Analysis.Rmd: $(P-M)/VNM_adm1.rds $(C-F)/fun-maps.R  $(C-F)/fun_03_ipums_age-boxplots.R $(P-I)/heads.RData $(P-I)/retirement.rds
	touch $(R)/01_ABM-report_03_Analysis.Rmd


## IPUMS data analysis and plots =============================================#
# import IPUMS data and get agricultural heads summaries
$(P-I)/heads.RData: $(C-DC)/01_IPUMS_import.R
	Rscript -e "source('$<')"
	
# dependency - multiple outputs
$(P-I)/retirement.rds: $(C-DC)/01_IPUMS_import.R

	
maps: $(FIG/maps)
## VIETNAM MAPS ==============================================================#
# plot two maps, one with, one without lables (psfrag)
$(FIG/maps): $(C-P)/01_plot-maps.R $(P-M)/VNM_adm1.rds $(C-F)/fun-maps.R
	Rscript -e "out <- '$(@D)'; source('$<')"

# processed map data: extract and simplify and add dataframe	
$(P-M)/VNM_adm1.rds:	$(C-DC)/00_gamd-maps.R $(R-M)/VNM_adm1.rds 
	Rscript -e "source('$<')"

# raw map data download
$(R-M)/VNM_adm1.rds:
	Rscript -e "download.file('http://biogeo.ucdavis.edu/data/gadm2.8/rds/VNM_adm1.rds', 'data/raw/maps/VNM_adm1.rds', mode = 'wb')"
