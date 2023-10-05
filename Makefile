# Example makefile

# Configs ----

# Define variables (directories and final report)
DIR := .
DATA_DIR := $(DIR)/data
RES_DIR := $(DIR)/results
R_DIR := $(DIR)/R
ROUT_DIR := $(R_DIR)/Rout
REPORT_DIR := $(DIR)/report
REPORT := $(REPORT_DIR)/report.pdf

# List of R files
R_FILES := $(wildcard $(R_DIR)/*.R)
# Generate output file names based on input R script names
R_OUTPUT_FILES := $(patsubst $(R_DIR)/%.R, $(ROUT_DIR)/%.Rout, $(R_FILES))
# Result Files
RES_FILES := $(wildcard $(RES_DIR)/*)
# Data files
DATA_FILES := $(wildcard $(DATA_DIR)/*.csv)

# Targets ----

all: create_directories run_rscripts generate_report

# Target to make directories if they do not exist
create_directories:
	@mkdir -p $(DATA_DIR)
	@mkdir -p $(RES_DIR)
	@mkdir -p $(ROUT_DIR)
	@mkdir -p $(REPORT_DIR)

# Rout targets depending on .R scripts in R directory
$(ROUT_DIR)/%.Rout: $(R_DIR)/%.R | create_directories
	R CMD BATCH $< $@

# Target R depends on the execution of .Rout files and removes them before execution
run_rscripts: | create_directories
	@rm -f $(R_OUTPUT_FILES)
	$(MAKE) $(R_OUTPUT_FILES)

# Generate the Quarto report to the current directory
generate_report: $(RES_FILES) | create_directories run_rscripts
	@if ! which tinytex > /dev/null 2>&1; then \
		quarto install tinytex; \
	fi
	quarto render $(R_DIR)/03-report.qmd --to pdf
	@echo "Quarto report run"
	@mv $(R_DIR)/03-report.pdf $(REPORT)  # Move the PDF to the results directory

# Clean up stray files
.PHONY: clean
clean:
	find . -name "*.RData" -type f -exec rm -f {} +
	rm -rf $(ROUT_DIR)  # Remove the .Rout folder
	@echo "Cleaned *.RData files and $(ROUT_DIR)."
