
# VARIABLE DEFINITIONS
# root directory
DIR = .


# journal (and its appendix) render to  pdf
$(DIR)/docs/Journal-migration-and-consolidation.pdf: $(DIR)/journals/Journal-migration-and-consolidation.Rmd $(DIR)/journals/Project-folder-organization-background.Rmd
	Rscript -e "require(rmarkdown); render('$<', output_dir = '$(DIR)/docs/', output_format = 'pdf_document' )"

# journal (and its appendix) render to  html
$(DIR)/docs/Journal-migration-and-consolidation.html: $(DIR)/journals/Journal-migration-and-consolidation.Rmd $(DIR)/journals/Project-folder-organization-background.Rmd
	Rscript -e "require(rmarkdown); render('$<', output_dir = '$(DIR)/docs/', output_format = 'html_document' )"

all: $(DIR)/docs/Journal-migration-and-consolidation.pdf $(DIR)/docs/Journal-migration-and-consolidation.html
