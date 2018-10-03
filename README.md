
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- devtools::rmarkdown::render("README.Rmd") -->
<!-- Rscript -e "library(knitr); knit('README.Rmd')" -->
Run programs outside of R <img src="logo.png" height="200" align="right"/>
==========================================================================

> The Outsider is always unhappy, but he is an agent that ensures the happiness for millions of 'Insiders'.<br><br> *[The Outsider, Wilson, 1956](https://en.wikipedia.org/wiki/The_Outsider_(Colin_Wilson)).*

<br> Integrating external programs into a deployable, R workflow can be challenging. Although there are many useful functions and packages (e.g. `system()` or `reticulate`) for calling code and software from alternative languages, these approaches require users to independently install dependant software and may not work across platforms.`outsider` aims to make this easier by allowing users to install, run and control programs *outside of R* across all operating systems.

Installation
------------

To install the development version of the package ...

``` r
devtools::install_github('AntonelliLab/outsider')
```

Additionally, you will also need to install **Docker desktop**. To install Docker visit the Docker website and follow the instructions for your operating system: [Install Docker](https://www.docker.com/products/docker-desktop).

Quick examples
--------------

``` r
library(outsider)
# outsider modules are hosted on GitHub
# this repo is a demonstration outsider module
# it contains a function for printing 'Hello World!' in Ubuntu 18.04
repo <- 'dombennett/om..hello.world..1.0'
module_install(repo = repo)
# look up the help files for the module
module_help(repo = repo)
# import the 'hello_world' function
hello_world <- module_import(fname = 'hello_world', repo = repo)
# run the imported function
hello_world()
#> Hello World!
```

Available external programs
---------------------------

**Listing will appear soon!**

How does it work?
-----------------

> Dans l'obscurité de ma prison roulante, j'ai retrouvé un à un, comme du fond de ma fatigue, tous les bruits familiers d'une ville que j'aimais et d'une certaine heure où il m'arrivait de me sentir content. Le cri des vendeurs de journaux dans l'air déjà détendu, les derniers oiseaux dans le square, l'appel des marchands de sandwiches, la plainte des tramways dans les hauts tournants de la ville et cette rumeur du ciel avant que la nuit bascule sur le port, tout cela recomposait pour moi un itinéraire d'aveugle, que je connaissais bien avant d'entrer en prison.<br><br> *[L'étranger, Camus, 1942](https://en.wikipedia.org/wiki/The_Stranger_(Camus_novel)).*

Things can a get a little existentialist when coding. Not everything works; bugs, errors and failures. This can be especially true when you're forced to pull code together from multiple programs and on different operating systems. But even during these darkest moments, there can be light.

The light in this case comes from a big, blue whale called [docker](https://www.docker.com/) and a weird cephalopod-mammal hybrid called [GitHub](https://github.com/).

Version
-------

Development version 0.

Maintainer
----------

[Dom Bennett](https://github.com/DomBennett)
