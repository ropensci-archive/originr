#' Check invasive species status for a set of species from GRIIS database
#'
#' @export
#'
#' @param name character; a string with the scientific species name in the form of
#'    "Genus species". Default is NULL: return all records.
#' @param impacts character containing either "Yes" or "No". Default to NULL:
#'     return al. records.
#' @param verified character containing either "Yes" or "No". Default to NULL:
#'     return all records.
#' @param country character containing a valid name of a country for which to
#'     filter the results. Default to NULL: return all records.
#' @param kindom character containing a valid name of a kindom (Plantae, ) for
#'     which to filter the results. Default to NULL: return all records.
#' @param type character containing a valid name of a environment type (terrestrial,
#'     for which to filter the results. Default to NULL: return all records.
#' @return A data.frame with species names, country where recorded,
#'    origin and source among other fields.
#'
#' @description This retrieves information from GRIIS (http://www.griis.org/) and
#' returns all the queried records. As other functions in this package, the
#' function is as good as the database is.
#'
#' @author Ignasi Bartomeus \email{nacho.bartomeus@@gmail.com}
#' @examples \dontrun{
#' sp <- "Carpobrotus edulis"
#' ## first species is invasive, second one is not.
#' griis(name = "Carpobrotus edulis")
#' griis(name = "Carpobrotus edulis", country = "Portugal")
#'
#' sp <- c("Carpobrotus edulis", "Rosmarinus officinalis", "Acacia mangium",
#' "Archontophoenix cunninghamiana", "Antigonon leptopus")
#' gisd(sp)
#' gisd(sp, simplify = TRUE)
#' }
#'
griis <- function(name = NULL, impacts = NULL, verified = NULL, country = NULL,
                  kindom = NULL, type = NULL){
  #checks that can be implmented
  #species is well spelled
  #country is well spelled
  #Kindom is one of Plantae
  #verification is Yes/NO
  #impacts is Yes/No
  #type is terrestrial...
  #Parse url and extract table
  doc <- read.table(paste0(griis_base(), "name=", name, "&impacts=", impacts,
                           "&verified=", verified, "&country=", country,
                           "&kindom=", kindom, "&type=", type),
                    header = TRUE, sep = ";")
  colnames(doc)[7] <- "Evidence.of.Impacts"
  colnames(doc)[8] <- "Verification"
  return(doc[,-11])
}

griis_base <- function() "http://www.griis.org/export_csv.php?"


