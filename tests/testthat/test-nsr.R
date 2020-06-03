test_that("nsr works", {
  skip_on_cran()

  vcr::use_cassette("nsr", {
    aa <- nsr("Pinus ponderosa", "United States")
  })

  expect_is(aa, "data.frame")
  expect_named(aa)
  expect_equal(aa$species, "Pinus ponderosa")
  expect_equal(aa$native_status, "N")
})

test_that("nsr fails well", {
  skip_on_cran()

  expect_error(nsr(), "argument \"country\" is missing")

  vcr::use_cassette("nsr_no_results", {
    bb <- nsr(species = "adadfd", country = "United States")
  })
  
  expect_equal(NROW(bb), 1)
})
