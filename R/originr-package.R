#' originr - Species Origin Data
#'
#' @importFrom httr GET content stop_for_status warn_for_status
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
NULL