

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
all: $(DOCS)/j-migration.html $(DOCS)/j-migration.pdf

# journal (and its appendix) render to  html
$(DOCS)/j-migration.html: $(JOURNALS)/j-migration.Rmd $(JOURNALS)/j-appendix1.Rmd
	$(KNIT-HTML)

# journal (and its appendix) render to  pdf
$(DOCS)/j-migration.pdf:  $(JOURNALS)/j-migration.Rmd $(JOURNALS)/j-appendix1.Rmd
	$(KNIT-PDF)


