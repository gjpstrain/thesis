# Add the rocker/verse Docker image for R 4.5.1
FROM rocker/verse:4.5.1

# Add our files to container
ADD chapters_quarto/ /home/rstudio/chapters_quarto/
ADD chapters_tex/ /home/rstudio/chapters_tex/
ADD data/ /home/rstudio/data/
ADD supplied_graphics/ /home/rstudio/supplied_graphics/
ADD thesis_cache/ /home/rstudio/thesis_cache/
ADD _quarto.yml /home/rstudio/
ADD chapter_7_supplementary_material.pdf /home/rstudio/
ADD finalise_thesis.r /home/rstudio/
ADD main.tex /home/rstudio/
ADD README.md /home/rstudio/
ADD reformat_tex.r /home/rstudio/
ADD thesis.bib /home/rstudio/
ADD thesis.Rproj /home/rstudio/
ADD uom_logo.pdf /home/rstudio/
ADD uom_thesis_casson.cls /home/rstudio/

# Fix permissions so that the rstudio user can write to all files
RUN chown -R rstudio:rstudio /home/rstudio

# Set the working directory for RStudio/Quarto
WORKDIR /home/rstudio

# Add appropriate versions of required R packages to container
RUN R -e "install.packages('devtools')"
RUN R -e "require(devtools)"
RUN R -e "install.packages('remotes')"

RUN R -e "devtools::install_version('MASS', version = '7.3-65', dependencies = T)"
RUN R -e "devtools::install_version('ggdist', version = '3.3.3', dependencies = T)"
RUN R -e "devtools::install_version('ggpubr', version = '0.6.1', dependencies = T)"
RUN R -e "devtools::install_version('conflicted', version = '1.2.0', dependencies = T)"
RUN R -e "devtools::install_version('png', version = '0.1-8', dependencies = T)"
RUN R -e "devtools::install_version('cowplot', version = '1.2.0', dependencies = T)"
RUN R -e "devtools::install_version('GGally', version = '2.4.0', dependencies = T)"
RUN R -e "devtools::install_version('hexbin', version = '1.28.5', dependencies = T)"
RUN R -e "devtools::install_version('geomtextpath', version = '0.2.0', dependencies = T)"
RUN R -e "devtools::install_version('emmeans', version = '1.11.2-8', dependencies = T)"
RUN R -e "devtools::install_version('scales', version = '1.4.0', dependencies = T)"
RUN R -e "devtools::install_version('buildmer', version = '2.12', dependencies = T)"
RUN R -e "devtools::install_version('lme4', version = '1.1-37', dependencies = T)"
RUN R -e "devtools::install_version('kableExtra', version = '1.4.0', dependencies = T)"
RUN R -e "devtools::install_version('afex', version = '1.5-0', dependencies = T)"
RUN R -e "devtools::install_version('papaja', version = '0.1.3', dependencies = T)"
RUN R -e "devtools::install_version('broom.mixed', version = '0.2.9.6', dependencies = T)"
RUN R -e "devtools::install_version('insight', version = '1.4.2', dependencies = T)"
RUN R -e "devtools::install_version('qwraps2', version = '0.6.1', dependencies = T)"
RUN R -e "devtools::install_version('lmerTest', version = '3.1-3', dependencies = T)"
RUN R -e "devtools::install_version('tinylabels', version = '0.2.5', dependencies = T)"
RUN R -e "devtools::install_version('formattable', version = '0.2.1', dependencies = T)"
RUN R -e "devtools::install_version('effectsize', version = '1.0.1', dependencies = T)"
RUN R -e "devtools::install_version('r2glmm', version = '0.1.3', dependencies = T)"
RUN R -e "devtools::install_version('DescTools', version = '0.99.60', dependencies = T)"
RUN R -e "devtools::install_version('Matrix', version = '1.7-3', dependencies = T)"
RUN R -e "devtools::install_version('irr', version = '0.84.1', dependencies = T)"
RUN R -e "devtools::install_version('ggh4x', version = '0.3.1', dependencies = T)"
RUN R -e "devtools::install_version('ordinal', version = '2023.12-4.1', dependencies = T)"
RUN R -e "devtools::install_version('ggrain', version = '0.0.4', dependencies = T)"
RUN R -e "devtools::install_version('quarto', version = '1.5.1', dependencies = T)"
RUN R -e "devtools::install_github('bbc/bbplot', dependencies = T)"


# install required tex packages

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

# manually add calibri font 

# Copy Calibri fonts into the container
COPY fonts/ /usr/share/fonts/truetype/calibri/

# Refresh font cache so system + fontspec (LuaLaTeX/XeLaTeX) can see them
RUN fc-cache -fv
