% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search.R
\name{module_details}
\alias{module_details}
\title{Look up details on module(s)}
\usage{
module_details(repo = NULL, service = c("github", "bitbucket", "gitlab"))
}
\arguments{
\item{repo}{Vector of one or more outsider module repositories, default NULL.}

\item{service}{Code-sharing service, e.g. GitHub}
}
\value{
tbl_df
}
\description{
Return a tbl_df of information for outsider module(s) for a
given code-sharing service. If \code{repo} is NULL, will return details on
all available modules.
}
\details{
Module details in tibble format include: repository name
(user/repo), last time repo was updated, number of watchers (or stars in the
case of GitLab), url to web presence, names of tagged versions.
}
\examples{
library(outsider)
# return table of ALL available modules on GitHub
# NOT RUN - takes too long
# (available_modules <- module_search())

# look-up specific modules
repo <- 'dombennett/om..goodbye.world'
(suppressWarnings(module_details(repo = repo))) # no module exists, expect warning
repo <- 'dombennett/om..hello.world'
(module_details(repo = repo))
}
\seealso{
Other public: 
\code{\link{is_module_installed}()},
\code{\link{module_functions}()},
\code{\link{module_help}()},
\code{\link{module_import}()},
\code{\link{module_installed}()},
\code{\link{module_search}()},
\code{\link{module_uninstall}()}
}
\concept{public}
