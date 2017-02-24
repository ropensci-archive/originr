mssg <- function(v, ...) if (v) message(...)

orc <- function(l) Filter(Negate(is.null), l)

todf <- function(x) {
  (xyz <- data.table::setDF(
    data.table::rbindlist(x, use.names = TRUE, fill = TRUE)
  ))
}
