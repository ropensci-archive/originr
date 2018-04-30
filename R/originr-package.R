#' originr - Species Origin Data
#'
#' @importFrom crul HttpClient
#' @importFrom jsonlite fromJSON
#' @importFrom taxize get_uid classification get_tsn itis_native
#' @importFrom xml2 read_xml xml_find_all xml_text
#' @importFrom data.table rbindlist setDF
#' @name originr-package
#' @aliases originr
#' @docType package
#' @keywords package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Ignasi Bartomeus \email{nacho.bartomeus@@gmail.com}
#'
#' @section Data sources in the package:
#' \itemize{
#'  \item Encyclopedia of Life (http://eol.org)
#'  \item Flora Europaea (http://rbg-web2.rbge.org.uk/FE/fe.html)
#'  \item Global Invasive Species Database (http://www.iucngisd.org/gisd)
#'  \item Native Species Resolver (http://bien.nceas.ucsb.edu/bien/tools/nsr/nsr-ws/)
#'  \item Integrated Taxonomic Information Service (http://www.itis.gov/)
#' }
NULL

#' Vector of country names for use with NSR
#'
#' @format A vector of countries of length 251
#' @name nsr_countries
#' @docType data
#' @keywords data
NULL

#' NSR political divisions
#'
#' @format A data frame with 73 rows and 2 variables:
#' \describe{
#'   \item{country}{Country name}
#'   \item{state_province}{State or province name}
#' }
#' 
#' @name nsr_pol_divisions
#' @docType data
#' @keywords data
NULL
