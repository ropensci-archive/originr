#' Check invasive species status for a species from GRIIS database
#'
#' @export
#'
#' @param name character; a string with the scientific species name in the
#' form of "Genus species". Default is NULL: return all records.
#' @param impacts character; "Yes" for returning only records with impacts.
#' Default to NULL: return all records.
#' @param verified character; "Yes" for returning only verified records.
#' Default to NULL: return all records.
#' @param country character containing a valid name of a country for which to
#'     filter the results. Default to NULL: return all records.
#' @param kindom character containing a valid name of a kindom (plantae,
#' animalia, fungi, protozoa, chromista, others, ) for which to filter the
#' results. Default to NULL: return all records.
#' @param type character containing a valid name of a environment type
#'    (terrestrial, freshwater, marine, brackish, host) for which to filter
#'    the results. Default to NULL: return all records.
#' @param ... curl options passed on to \code{\link[crul]{HttpClient}}
#' @return A data.frame with species names, country where recorded,
#'    origin and source among other fields.
#'
#' @note It seems as 'name' overrides 'kindom', which means records from a
#'    a plant species will be returned even if kindom is set to animalia.
#'
#' @description This retrieves information from GRIIS (http://www.griis.org/)
#' and returns all the queried records. As other functions in this package, the
#' function is as good as the database is.
#'
#' @author Ignasi Bartomeus \email{nacho.bartomeus@@gmail.com}
#' @examples \dontrun{
#' griis(name = "Carpobrotus edulis")
#' griis(name = "Carpobrotus edulis", country = "Portugal")
#' }
#'
griis <- function(name = NULL, impacts = NULL, verified = NULL, country = NULL,
                  kindom = NULL, type = NULL, ...){
  #country is well spelled
  countries <- c("Afghanistan",
                 "Albania",
                 "Algeria",
                 "Andorra",
                 "Angola",
                 "Antigua and Barbuda",
                 "Argentina",
                 "Armenia",
                 "Bangladesh",
                 "Barbados",
                 "Belarus",
                 "Belgium",
                 "Belize",
                 "Benin",
                 "Bhutan",
                 "Bolivia",
                 "Bosnia and Herzegovina",
                 "Botswana",
                 "Brazil",
                 "Brunei Darussalam",
                 "Bulgaria",
                 "Burkina Faso",
                 "Burundi",
                 "Cabo Verde",
                 "Cambodia",
                 "Cameroon",
                 "Canada",
                 "C\u00f4te d'Ivoire",
                 "Central African Republic",
                 "Chad",
                 "Chile",
                 "China",
                 "Colombia",
                 "Comoros",
                 "Cook Islands",
                 "Croatia",
                 "Cuba",
                 "Cyprus",
                 "Democratic Republic of the Congo",
                 "Denmark",
                 "Djibouti",
                 "Egypt",
                 "Equatorial Guinea",
                 "Eritrea",
                 "Ethiopia",
                 "Finland",
                 "Gabon",
                 "Gambia (the)",
                 "Germany",
                 "Ghana",
                 "Greece",
                 "Guinea-Bissau",
                 "Guyana",
                 "Iceland",
                 "Indonesia",
                 "Iran (Islamic Republic of)",
                 "Ireland",
                 "Jamaica",
                 "Japan",
                 "Jordan",
                 "Kenya",
                 "Lao People's Democratic Republic",
                 "Latvia",
                 "Libya",
                 "Lithuania",
                 "Mali",
                 "Marshall Islands",
                 "Mauritania",
                 "Mongolia",
                 "Montegero",
                 "Montenegro",
                 "Morocco",
                 "Mozambique",
                 "Myanmar",
                 "Nepal",
                 "New Zealand",
                 "Niger",
                 "Nigeria",
                 "Norway",
                 "Pakistan",
                 "Paraguay",
                 "Peru",
                 "Poland",
                 "Portugal",
                 "Republic of Moldova",
                 "Romania",
                 "Rwanda",
                 "Saint Kitts and Nevis",
                 "Saint Vicent and the Grenadines",
                 "Sao Tome and Principe",
                 "Saudi Arabia",
                 "Senegal",
                 "Serbia",
                 "Seychelles",
                 "Sierra Leone",
                 "Singapore",
                 "Slovakia",
                 "Somalia",
                 "South Africa",
                 "South Sudan",
                 "Spain",
                 "Sri Lanka",
                 "Sudan",
                 "Suriname",
                 "Swaziland",
                 "Switzerland",
                 "Taiwan",
                 "Thailand",
                 "The former Yugoslav Republic of Macedonia",
                 "Togo",
                 "Tunisia",
                 "Turkey",
                 "Uganda",
                 "Ukraine",
                 "United Arab Emirates",
                 "United Republic of Tanzania",
                 "Uruguay",
                 "Venezuela",
                 "Viet Nam",
                 "Yemen",
                 "Zambia",
                 "Zimbabwe")
  if(!is.null(country)){
    if(!country %in% countries){
      stop(paste("country should be one of", paste(countries, collapse = ", ")))
    }
  }
  #Kinndom is valid
  if(!is.null(kindom)){
    if(!kindom %in% c("animalia", "plantae", "fungi",
                    "protozoa", "chromista", "others")){
    stop("kindom should be one of animalia, plantae, fungi,
         protozoa, chromista, others")
    }
  }
  #verification is Yes or NULL
  if(!is.null(verified)){
    if(!verified %in% c("Yes")){
    stop("verified should be Yes or NULL")
    }
    verified <- ifelse(verified == "Yes", "1", "")
  }
  #impacts is Yes or NULL
  if(!is.null(impacts)){
    if(!impacts %in% c("Yes")){
    stop("impacts should be Yes or NULL")
    }
    impacts <- ifelse(impacts == "Yes", "1", "")
  }
  #type is terrestrial...
  if(!is.null(type)){
    if(!type %in% c("terrestrial", "freshwater", "marine",
                  "brackish", "host")){
    stop("type should be one of terrestrial, freshwater,
         marine, brackish, host")
    }
  }
  #Parse url and extract table
  args <- orc(list(name = name, impacts = impacts,
               verified = verified, country = country,
               kindom = kindom, type = type))
  cli <- crul::HttpClient$new(url = griis_base(), opts = list(...))
  x <- cli$get("export_csv.php", query = args)
  warn_status(x)
  doc <- utils::read.table(x$url, header = TRUE, sep = ";",
                           stringsAsFactors = FALSE)
  colnames(doc)[which(colnames(doc) == "Evidence.of.Impacts..Y.N.")] <-
    "Evidence.of.Impacts"
  colnames(doc)[which(colnames(doc) == "Verification..Y.N.")] <- "Verified"
  return(doc[,-which(colnames(doc) == "X")])
}

griis_base <- function() "http://www.griis.org"

