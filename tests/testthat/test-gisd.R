test_that("gisd", {
  skip_on_cran()

  sp <- c("Carpobrotus edulis", "Rosmarinus officinalis")
  vcr::use_cassette("gisd", {
    aa <- gisd(sp, messages = FALSE)
  })

  expect_is(aa, "list")
  expect_named(aa, sp)
  expect_is(aa[[1]], "list")
  expect_is(aa[[2]], "list")
})

test_that("gisd fails well - species not found when searching GBIF", {
  skip_on_cran()

  sp <- "asdfadsf"
  vcr::use_cassette("gisd_not_found", {
    aa <- gisd(sp, messages = FALSE)
  })

  expect_is(aa, "list")
  expect_named(aa, sp)
  expect_equal(aa[[1]]$status, "Not in GISD")
})
