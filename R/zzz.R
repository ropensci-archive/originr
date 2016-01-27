mssg <- function(v, ...) if (v) message(...)

traitsc <- function(l) Filter(Negate(is.null), l)
