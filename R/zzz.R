mssg <- function(v, ...) if (v) message(...)

orc <- function(l) Filter(Negate(is.null), l)

todf <- function(x) {
  (xyz <- data.table::setDF(
    data.table::rbindlist(x, use.names = TRUE, fill = TRUE)
  ))
}

`%||%` <- function (x, y) if (is.null(x) || length(x) == 0) y else x

warn_status <- function(x) {
  if (!x$status_code < 300) {
    stat <- x$status_http()
    warning(sprintf("%s: %s - %s", 
      x$status_code %||% "", stat$message %||% "", stat$explanation %||% ""))
  }
}
