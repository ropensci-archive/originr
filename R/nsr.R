#' Search the Native Species Resolver
#'
#' @export
#' @param species (character) One or more species names. required.
#' @param country (character) A country name. required.
#' @param stateprovince (character) A state or province name
#' @param countyparish (character) A county or parish name
#' @param ... curl options passed on to [crul::HttpClient]
#' @references http://bien.nceas.ucsb.edu/bien/tools/nsr/nsr-ws/
#' @details Currently, only one name is allowed per request. We loop internally
#' over a list of length > 1, but this will still be slow due to only 1
#' name per request.
#'
#' Note that this service can be quite slow.
#' 
#' @section political names:
#' 
#' - `nsr_countries`: is a vector of country names that we use to check
#' your country names
#' - `nsr_pol_divisions`: is a data.frame of country names and state/province
#' names that we used to check your parameter inputs - these are for checklists 
#' that NSR has complete coverage for
#' 
#' @examples \dontrun{
#' nsr("Pinus ponderosa", country = "United States")
#' nsr(c("Pinus ponderosa", "Poa annua"), country = "United States")
#' splist <- c("Pinus ponderosa", "Poa annua", "bromus tectorum", "Ailanthus altissima")
#' nsr(splist, country = "United States")
#' nsr(splist, country = "United States", stateprovince = "California")
#'
#' # curl options
#' nsr("Pinus ponderosa", "United States", verbose = TRUE)
#' }
nsr <- function(species, country, stateprovince = NULL, countyparish = NULL, ...) {
  if (!country %in% nsr_countries) {
    warning("country ", country, " not in the NSR list of countries")
  }
  if (!is.null(stateprovince)) {
    if (!stateprovince %in% nsr_pol_divisions$state_province) {
      warning("state/province ", stateprovince, 
        " not in the NSR list of state/provinces")
    }
  }
  tmp <- lapply(species, function(z) {
    args <- orc(list(format = 'json', species = z, country = country,
                     stateprovince = stateprovince, countyparish = countyparish))
    x <- nsr_GET(args, ...)
    orc(x)
  })
  df <- data.table::rbindlist(tmp, fill = TRUE, use.names = TRUE)
  (df <- data.table::setDF(df))
}

nsr_GET <- function(args, ...) {
  cli <- crul::HttpClient$new(url = nsr_base(), opts = list(...))
  x <- cli$get("bien/apps/nsr/nsr_ws.php", query = args)
  x$raise_for_status()
  xx <- jsonlite::fromJSON(x$parse("UTF-8"), FALSE)$nsr_results
  if (length(xx) == 0) NULL else xx[[1]]$nsr_result
}

nsr_base <- function() "http://bien.nceas.ucsb.edu"
