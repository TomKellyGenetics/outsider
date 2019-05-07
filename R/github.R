# URL functions

# Vars ----
gh_url <- 'https://github.com'
gh_api_url <- 'https://api.github.com'
gh_search_repo_url <- paste0(gh_api_url, '/search/repositories')
gh_raw_url <- 'https://raw.githubusercontent.com/'
travis_api_url <- 'https://api.travis-ci.org/repos/'

# Auth token
authtoken_get <- function(joiner = c('?', '&')) {
  joiner <- match.arg(joiner)
  tkn <- Sys.getenv("GITHUB_PAT")
  if (nchar(tkn) > 0) {
    tkn <- paste0(joiner, 'access_token=', tkn)
  } else {
    tkn <- NULL
  }
  tkn
}

# Private ----
#' @name repo_search
#' @title Search for repository
#' @description Return GitHub API item for specific repository.
#' @param repo GitHub repo
#' @return data.frame
#' @family private-search
repo_search <- function(repo) {
  search_args <- paste0('?q=', repo, '&', 'Type=Repositories',
                        authtoken_get('&'))
  github_res <- jsonlite::fromJSON(paste0(gh_search_repo_url, search_args))
  if (github_res[['total_count']] == 0) {
    warning('No ', char(repo), ' found.', call. = FALSE)
    return(data.frame())
  }
  if (github_res[['total_count']] > 1) {
    warning('Too many possible matching repos for ', char(repo), '.',
            call. = FALSE)
    return(data.frame())
  }
  github_res[['items']]
}

#' @name all_search
#' @title Search for outsider modules
#' @description Returns GitHub API item results for outsider module search.
#' @return data.frame
#' @family private-search
all_search <- function() {
  search_args <- paste0('?q=om..+in:name+outsider-module+in:description',
                        '&', 'Type=Repositories', authtoken_get('&'))
  github_res <- jsonlite::fromJSON(paste0(gh_search_repo_url, search_args))
  if (github_res[['incomplete_results']]) {
    warning('Not all repos discovered.')
  }
  github_res[['items']]
}

#' @name build_status
#' @title Look-up details on program
#' @description Is build passing? Returns either TRUE or FALSE.
#' @param repo GitHub repo
#' @return Logical
#' @family private-search
build_status <- function(repo) {
  res <- repo_search(repo = repo)
  url <- paste0(travis_api_url, res[['full_name']], '.json')
  build_info <- try(expr = jsonlite::fromJSON(txt = url), silent = TRUE)
  !inherits(build_info, 'try-error') &&
    !is.null(build_info[["last_build_status"]]) &&
    build_info[["last_build_status"]] == 0
}

#' @name read_yaml
#' @title Safely read om.yaml
#' @description Return list of 'program' and 'details'.
#' @param repo GitHub repo
#' @return list
#' @family private-search
read_yaml <- function(repo) {
  yaml_url <- paste0(gh_raw_url, repo, '/master/om.yml')
  tryCatch(expr = {
    lines <- readLines(con = yaml_url)
  }, error = function(e) {
    lines <- NULL
  }, warning = function(e) {
    lines <- NULL
  })
  string <- paste(lines, collapse = "\n")
  res <- yaml::yaml.load(string = string, error.label = NULL)
  list('program' = res[['program']], 'details' = res[['details']])
}

#' @name yaml
#' @title Module YAML information
#' @description Return tbl_df of all YAML information of given outsider
#' module repos.
#' @param repos Character vector of outsider module repositories.
#' @return tbl_df
#' @family private-search
yaml <- function(repos) {
  extract <- function(x, i) {
    vapply(X = x, FUN = function(x, i) {
      res <- x[[i]]
      if (length(res) == 0) res <- ''
      res
    }, FUN.VALUE = character(1),
    i = i)
  }
  yaml <- lapply(X = repos, FUN = read_yaml)
  prgms <- extract(x = yaml, i = 'program')
  dtls <- extract(x = yaml, i = 'details')
  tibble::as_tibble(x = list(repo = repos, program = prgms, details = dtls))
}

#' @name tags
#' @title Module tags
#' @description Return tbl_df of module tags for a list of outsider
#' modules.
#' @param repos Character vector of outsider module repositories.
#' @return tbl_df
#' @family private-search
tags <- function(repos) {
  fetch <- function(repo) {
    api_url <- paste0(gh_api_url, '/repos/', repo, '/contents/dockerfiles',
                      authtoken_get('?'))
    raw_df <- try(jsonlite::fromJSON(api_url), silent = TRUE)
    if (!inherits(raw_df, 'try-error')) {
      tag <- raw_df[ ,'name']
      download_url <- paste0(gh_raw_url, repo, '/master/dockerfiles/',
                             raw_df[ ,'name'], '/Dockerfile')
    } else {
      warning('Unable to fetch data from GitHub for ', char(repo))
      download_url <- tag <- ''
    }
    data.frame(repo = repo, tag = tag, download_url = download_url,
               stringsAsFactors = FALSE)
  }
  res <- lapply(X = repos, FUN = fetch)
  res <- do.call(what = rbind, args = res)
  tibble::as_tibble(x = res)
}