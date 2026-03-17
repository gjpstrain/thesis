# Add the rocker/verse Docker image for R 4.5.3
FROM rocker/verse:4.5.3

# Set the working directory early
WORKDIR /home/rstudio

# Add renv files first (for better Docker layer caching)
ADD renv.lock /home/rstudio/
ADD .Rprofile /home/rstudio/
ADD renv/ /home/rstudio/renv/

# Install renv
RUN R -e "install.packages('renv', repos='https://cran.r-project.org')"

# Configure renv to use copying instead of symlinks in Docker
RUN R -e "renv::settings\$use.cache(FALSE)"

# Restore packages from lockfile (without cache/symlinks)
RUN R -e "renv::restore()"

# Add our files to container
ADD chapters_quarto/ /home/rstudio/chapters_quarto/
ADD chapters_tex/ /home/rstudio/chapters_tex/
ADD data/ /home/rstudio/data/
ADD supplied_graphics/ /home/rstudio/supplied_graphics/
ADD thesis_cache/ /home/rstudio/thesis_cache/
ADD _quarto.yml /home/rstudio/
ADD finalise_thesis.r /home/rstudio/
ADD main.tex /home/rstudio/
ADD README.md /home/rstudio/
ADD reformat_tex.R /home/rstudio/
ADD shared_functions.R /home/rstudio/
ADD thesis.bib /home/rstudio/
ADD thesis.Rproj /home/rstudio/
ADD uom_logo.pdf /home/rstudio/
ADD uom_thesis_casson.cls /home/rstudio/

# Install required tex packages
RUN R -e "tinytex::tlmgr_install(c( \
  'pdfx', \
  'everyshi', \
  'colorprofiles', \
  'xmpincl', \
  'titlesec', \
  'setspace', \
  'pgf', \
  'fontspec', \
  'tocloft', \
  'enumitem', \
  'appendix', \
  'caption', \
  'amsfonts', \
  'multirow', \
  'booktabs', \
  'lipsum', \
  'floatrow', \
  'siunitx', \
  'subfiles', \
  'natbib', \
  'luatex85', \
  'fancyref', \
  'biblatex', \
  'biber' \
))"

# Manually add calibri font 
COPY fonts/ /usr/share/fonts/truetype/calibri/

# Refresh font cache so system + fontspec (LuaLaTeX/XeLaTeX) can see them
RUN fc-cache -fv

# Fix permissions so that the rstudio user can write to all files
RUN chown -R rstudio:rstudio /home/rstudio