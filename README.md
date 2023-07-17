# rsaccharis
A rendering package for creating phylogenetic trees from SACCHARIS .json and .tree files,
in the R statistical computing language.

## Installation

Option 1 (TBD, we haven't uploaded rsaccharis to bioconda yet, so this doesn't work right now!):
- The rsaccharis package will be packaged for conda and distributed on the bioconda channel. 
  If you install the main SACCHARIS toool, rsaccharis will be automatically installed once this is 
  working. If you want to install rsaccharis on it's own, simply use `conda install rsaccharis`.

Option 2:
- You can install the latest R package by going to the releases section on the GitHub sidebar, downloading the 
  latest rsaccharis_x.x.x.tar.gz archive and  then using 
  `install.packages(file_name_and_path, repos = NULL, type="source")` in R or RStudio to install 
  using the downloaded archive.

Option 3:
- You can install the latest version of the repository by using the devtools package in r and the 
  following command: 
  `devtools::install_github(saccharis/rsaccharis)`
  This will automatically download and build the package using the latest version of the main branch 
  of the git repo. BEWARE that this is not guaranteed to be stable and functional.

#### Note to maintainers
Check MAINTENANCE.md for instructions on updating the packaging and uploading new versions 
to package repositories.