# rsaccharis
A rendering package for creating phylogenetic trees from [SACCHARIS 2](https://github.com/saccharis/SACCHARIS_2) .json and .tree files,
in the R statistical computing language.

## Installation

Option 1:
- The rsaccharis package is packaged for conda and distributed on the bioconda channel. To install r-saccharis on it's 
  own, simply use `conda install r-saccharis` after [setting up the bioconda channel](https://bioconda.github.io/).

[//]: # (UNCOMMENT LINE BELOW ONCE AUTO INSTALL IS WORKING PROPERLY)
[//]: # (  If you install the main SACCHARIS tool, rsaccharis will be automatically installed.)

Option 2:
- You can install the latest version of the repository by using the devtools package in r and the
  following command: 
  
  `devtools::install_github("saccharis/rsaccharis")`
  
  This will automatically download and build the package using the latest version of the main branch
  of the git repo. BEWARE that this is **not guaranteed to be stable** and functional, as beta release code may be 
  pushed to the repo before being fully tested.

Option 3:
- You can install the latest R package by going to the releases section on the GitHub sidebar, downloading the 
  latest rsaccharis_x.x.x.tar.gz archive and then using 
  `install.packages(file_name_and_path, repos = NULL, type="source")` in R or RStudio to install 
  using the downloaded archive.

## Usage
1. Change your working directory to where your SACCHARIS output files are located.

1. `library(rsaccharis)`			This initializes the R package.

1. `A_load_data()`				This first function will load in all the data, and it will prompt you to enter the file name for the .json and .tree output files from SACCHARIS.

1. `B_plots_all()`				This will then just go through all the plotting to make our default plots.

All plots are produced as PDFs, and can be further edited in vector graphics software (_e.g._ Inkscape). The .csv file producted by the R package includes all the metadata from CAZy as well as the assigned Tree IDs produced during plotting.

#### Note to maintainers
Check MAINTENANCE.md for instructions on updating the packaging and uploading new versions 
to package repositories.
