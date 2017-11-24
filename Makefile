

# VARIABLE DEFINITIONS  #######################################################
###############################################################################
# folders #####################################################################
DIR = .
DOCS = $(DIR)/docs
JOURNALS = $(DIR)/journals

# file lists ##################################################################
# migration journals
# J-MIG = $(DOCS)/j-migration.html $(DOCS)/j-migration.pdf
# migraiton sources
# J-MIG-SRC = $(JOURNALS)/j-migration.Rmd $(JOURNALS)/j-appendix1.Rmd

# commands ####################################################################
# recipe to knit pdf from first prerequisite
KNIT-PDF = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(DOCS)', output_format = 'pdf_document' )"

# recipe to knit pdf from first prerequisite
KNIT-HTML = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(DOCS)', output_format = 'html_document' )"


# DEPENDENCIES   ##############################################################
###############################################################################
all: $(DIR)/make.dot $(DOCS)/j-migration.html $(DOCS)/j-migration.pdf

# top level dependencies ######################################################
# make file .dot
$(DIR)/make.dot : $(DIR)/Makefile
	python makefile2dot.py < $< > make.dot

# make chart from .dot
#$(DIR)/make.dot

# journal (and its appendix) render to  html
$(DOCS)/j-migration.html: $(JOURNALS)/j-migration.Rmd $(JOURNALS)/j-appendix1.Rmd
	$(KNIT-HTML)

# journal (and its appendix) render to  pdf
$(DOCS)/j-migration.pdf:  $(JOURNALS)/j-migration.Rmd $(JOURNALS)/j-appendix1.Rmd
	$(KNIT-PDF)


