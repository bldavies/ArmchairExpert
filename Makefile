all: data package

data:
	Rscript data-raw/episodes.R

package:
	Rscript -e "devtools::install()"

.PHONY: all data package
