# Maintenance instructions
I recommend the following guides for reference:
- http://rcs.bu.edu/examples/r/tutorials/BuildingPackages/
- https://r-pkgs.org/

When updating the package, these are the main steps:
- Rebuild the R package, making sure to update the version number appropriately.
- Upload the new package to [GitHub](https://github.com/saccharis/rsaccharis), and tag it with the version number ONLY. 
  e.g. `1.0.1`
- Update conda build recipe and test that you can build and run the new conda package locally.
- Update the new conda package on bioconda.

## How to rebuild the R package when changes are made
- Open Rstudio
- Make sure the latest changes (e.g. bugfixes, features) are in your local system AND on the latest commit of the 
main git branch.
- Update the **version number** in the **DESCRIPTION** file.
- Run `library(devtools)` to load the devtools package (you may need to download and install devtools from the R website)
- Run `devtools::document()` to update documentation
- Run `devtools::check()` to check there are no errors while building the package, then fix any errors or warnings
- Once the package is free of errors and warnings, run `build(manual=TRUE)` to create the rsaccharis_\<ver\>.tar.gz file

## Uploading to github
- Before uploading to GitHub, make sure the changes you packaged in R are actually commited to the git repo, since the 
  tag associates both a package upload AND a git commit to the tag, and the code should match to simplify 
  troubleshooting.
- Upload the new package to the [releases section](https://github.com/saccharis/rsaccharis/releases) of the GitHub by 
  clicking on "Draft a new release", and tag it with the version number ONLY.
  e.g. `1.0.1` It's important the tag is exactly the same as the version number, since that's how the conda packaging 
  will find the archive to package it up in later steps.

## Updating conda packaging
Reference documentation [here](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html).
- Update the meta.yaml file for conda builds with any dependency changes (and any other build changes) and **update the 
  correct version number** and the SHA256 hash at the top of the file with the hash of the latest tar.gz archive uploaded
  to GitHub.
- Test that the conda package can be built locally. You can do this simply by running `conda build .` from the 
  rsaccharis folder in a terminal with conda set up.
- Once successfully built, you can install the newly created local package with `conda install rsaccharis --use-local`, 
  ideally in a fresh environment.
- Test that the newly installed package is working properly in the test conda environment.


## Updating for  bioconda
Reference documentation [here](https://bioconda.github.io/contributor/index.html).
- [optional] Do local bioconda packaging tests first, as per [bioconda instructions](https://bioconda.github.io/contributor/building-locally.html).
It can be challenging to get their packaging test tools installed though, (I recommend using the libmamba solver with 
conda or to just use mamba to install them) so if you can't install those tools just commit to our bioconda-recipes 
branch as per the next step and the automated tests will run on their server (this can take upwards of an hour though, 
so the feedback time is quite slow when there are errors).
- Modify the bioconda-recipes project and submit a PR for the new version to that repo. The PR will test the packaging
on bioconda servers and if it passes it will eventually be approved and merged by the bioconda team and then the latest
rsaccharis package will be available on bioconda. If the tests don't pass, fix the problems until they do, reach out on 
the bioconda gitter if you need help.

## You're done!
That's it! If you did all these steps correctly, you should now be able to download the new package off bioconda! 
Install it on a fresh machine and make sure it's working properly!