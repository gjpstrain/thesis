# If you only want to compile the final thesis, go straight to line 55

# If you want to compile each chapter from scratch, start from line 10

# NB if you are running the Docker container, you don't need to install 
# additional tex packages; this is handled by the Dockerfile

################################################################################

# First, install required packages

#install.packages("quarto")
#install.packages("tinytex")

# Load packages in

library(quarto)
library(tinytex)

# Following command renders all quarto chapters:

quarto_render("chapters_quarto/", output_format = "latex")

 # Following command renders only a single chapter:

quarto_render("chapters_quarto/7_belief_change.qmd", output_format = "latex")

# functions to reformat tex are stored in the local directory

source("reformat_tex.R")

folder_path <- "chapters_tex/chapters_quarto/"
replace_before_document_in_folder(folder_path)

################################################################################

# now we can use tinytex to compile the thesis
# if this is your first time using the template,
# you will need to install tinytex (the package), and
# then TinyTex (the engine)

#install.packages("tinytex")
#tinytex::reinstall_tinytex()

# because the UoM template uses lualatex, we have to manually install
# an additional package (just uncomment and run)

#tinytex::tlmgr_install("luatex85")

# sometimes the Tex Gyres Termes font is not found, so manually install it via
# tinytex

#tinytex::tlmgr_install("tex-gyre")

tinytex::lualatex("main.tex", bib_engine = "biber")




