#' Search for presence of taxonomic names in EOL invasive species databases.
#'
#' See Details for important information.
#'
#' @export
#' @param name A taxonomic name, or a vector of names.
#' @param dataset One of all, gisd100, gisd, isc, daisie, i3n, or mineps.
#' See the Details for what each dataset ID.
#' @param searchby One of 'grep' (exact match) or 'agrep' (fuzzy match)
#' @param page A maximum of 30 results are returned per page. This parameter
#' allows you to fetch more pages of results if there are more than 30 matches
#' (Default: 1)
#' @param per_page Results to get per page
#' @param key Your EOL API key; loads from .Rprofile.
#' @param messages (logical) If \code{TRUE} the actual taxon queried is printed 
#' on the console.
#' @param count (logical) If TRUE, give back a count of number of taxa listed
#' as invasive, if \code{FALSE} (default), the normal output is given.
#' @param ... curl options passed on to \code{\link[crul]{HttpClient}}
#'
#' @details
#' IMPORTANT: When you get a returned NaN for a taxon, that means it's not on
#' the invasive list in question. If the taxon is found, a taxon identifier
#' is returned.
#'
#' Beware that some datasets are quite large, and may take 30 sec to a minute to
#' pull down all data before we can search for your species. Note there is no
#' parameter in this API method for searching by taxon name.
#'
#' This function is vectorized, so you can pass a single name or a vector
#' of names.
#'
#' It's possible to return JSON or XML with the EOL API. However, this function
#' only returns JSON for now.
#'
#' Options for the dataset parameter are
#' \itemize{
#'  \item all - All datasets
#'  \item gisd100 - 100 of the World's Worst Invasive Alien Species
#'  (Global Invasive Species Database) http://eol.org/collections/54500
#'  \item gisd - Global Invasive Species Database 2013
#'  http://eol.org/collections/54983
#'  \item isc - Centre for Agriculture and Biosciences International Invasive
#'  Species Compendium (ISC) http://eol.org/collections/55180
#'  \item daisie - Delivering Alien Invasive Species Inventories for Europe
#'  (DAISIE) Species List http://eol.org/collections/55179
#'  \item i3n - IABIN Invasives Information Network (I3N) Species
#'  http://eol.org/collections/55176
#'  \item mineps - Marine Invaders of the NE Pacific
#'  Species http://eol.org/collections/55331
#' }
#'
#' Datasets are not updated that often. Here's last updated dates for some of
#' the datasets as of 2014-08-25
#'
#' \itemize{
#'  \item gisd100 updated 6 mos ago
#'  \item gisd  updated 1 yr ago
#'  \item isc updated 1 yr ago
#'  \item daisie updated 1 yr ago
#'  \item i3n updated 1 yr ago
#'  \item mineps updated 1 yr ago
#' }
#'
#' @return A list of data.frame's/strings with results, with each element
#' named by the input elements to the name parameter.
#' @references See info for each data source at
#' \url{http://eol.org/collections/55367/taxa}
#'
#' @examples \dontrun{
#' eol(name='Brassica oleracea', dataset='gisd')
#' eol(name=c('Lymantria dispar','Cygnus olor','Hydrilla verticillata',
#'   'Pinus concolor'), dataset='gisd')
#' eol(name='Sargassum', dataset='gisd')
#' eol(name='Ciona intestinalis', dataset='mineps')
#' eol(name=c('Lymantria dispar','Cygnus olor','Hydrilla verticillata',
#'   'Pinus concolor'), dataset='i3n')
#' eol(name=c('Branta canadensis','Gallus gallus','Myiopsitta monachus'),
#'    dataset='daisie')
#' eol(name=c('Branta canadensis','Gallus gallus','Myiopsitta monachus'),
#'   dataset='isc')
#'
#' # Count
#' eol(name=c('Lymantria dispar','Cygnus olor','Hydrilla verticillata',
#'   'Pinus concolor'), dataset='gisd', count = TRUE)
#' 
#' # curl options
#' eol(name='Sargassum', dataset='gisd', verbose = TRUE)
#' }
eol <- function(name, dataset="all", searchby = grep, page=NULL,
  per_page=NULL, key = NULL, messages=TRUE, count=FALSE, ...) {

  if (any(nchar(name) < 1)) stop("'name' must be longer than 0 characters")
  if (is.null(dataset)) stop("please provide a dataset name")
  datasetid <- switch(dataset,
           all = 55367,
           gisd100 = 54500,
           gisd = 54983,
           isc = 55180,
           daisie = 55179,
           i3n = 55176,
           mineps = 55331)

  args <- orc(list(id = datasetid, page = page, per_page = 500,
                   filter = 'taxa'))

  cli <- crul::HttpClient$new(url = 'http://eol.org/api/collections/1.0.json', 
    opts = list(...))
  tt <- cli$get(query = args)
  tt$raise_for_status()
  res <- jsonlite::fromJSON(tt$parse("UTF-8"), FALSE)
  data_init <- res$collection_items
  mssg(messages, sprintf("Getting data for %s names...", res$total_items))

  pages_get <- pages_left(res)

  if (!is.null(pages_get)) {
    out <- list()
    for (i in pages_get) {
      args <- orc(list(id = datasetid, page = i, per_page = 500,
                       filter = 'taxa'))
      tt <- cli$get(query = args)
      tt$raise_for_status()
      res <- jsonlite::fromJSON(tt$parse("UTF-8"), FALSE)
      out[[i]] <- res$collection_items
    }
    res2 <- orc(out)
    dat_all <- do.call(c, list(data_init, do.call(c, res2)))
    dat_all <- lapply(dat_all, "[", c("name", "object_id"))
    dat <- todf(dat_all)
  } else {
    dat_all <- lapply(data_init, "[", c("name","object_id"))
    dat <- todf(dat_all)
  }

  # search by name
  tmp <- stats::setNames(lapply(name, getmatches, y = searchby, z = dat), name)
  df <- do.call("rbind.data.frame",
                Map(function(x,y) {
                  data.frame(id = y, x, stringsAsFactors = FALSE)
                }, tmp, names(tmp)))
  df$db <- dataset
  names(df)[c(1,3)] <- c("searched_name","eol_object_id")
  row.names(df) <- NULL
  if (!count) df else length(na.omit(df$eol_object_id))
}

pages_left <- function(x) {
  tot <- x$total_items
  got <- length(x$collection_items)
  if (got < tot) {
    seq(1, ceiling((tot - got)/500), 1) + 1
  }
}

getmatches <- function(x, y, z) {
  matched <- eval(y)(x, z$name)
  if (identical(matched, integer(0))) {
    dff <- data.frame(name = x, object_id = NaN, stringsAsFactors = FALSE)
    dff$name <- as.character(dff$name)
    dff
  } else {
    z[matched, ]
  }
}
