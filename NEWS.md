originr 0.3.0
=============

### NEW FEATURES

* replaced HTTP clients, now using `crul` package (#13)
* new function `eol_invasive_data()` to get the global data.frame of invasive species data from EOL.

### MINOR IMPROVEMENTS

* Improved documentation around `eol()` behavior. `dataset="all"` does not encompass, or at least does not include data to indicate that it encompasses, the individual EOL invasives datasets. There's no response from EOL on this, so we're stuck with the behavior  (#10) (#18)
* Added internal datasets for `nsr()` function. Now internally we check whether the country, and state/province name passed in is in the acceptable set, and throw warning if not (#19)


originr 0.2.0
=============

### NEW FEATURES

* Added a new data source: Global Register of Introduced and Invasive
Species (GRIIS). See `griis()` (#5) (#7)

### BUG FIXES

* Fix to `flora_europaea()` to convert factors to character and 
to stop with meaningful message when more than one species 
passed in (#8)


originr 0.1.0
=============

### NEW FEATURES

* Released to CRAN.
