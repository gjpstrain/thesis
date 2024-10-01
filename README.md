# Instructions

 - Each chapter is written using quarto in Rstudio.
 - These .qmd files are stored in `chapters_quarto`.
 - The `finalise.r` script renders each .qmd separately, outputs the .tex to `chapters_tex/chapters_quarto`, strips the preamble, then uses tinytex to knit the final thesis together.
