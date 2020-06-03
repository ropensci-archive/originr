test_that("is_native - america, uses taxize::get_tsn", {
  skip_on_cran()

  sp <- c("Lavandula stoechas", "Carpobrotus edulis",
    "Rhododendron ponticum", "Alkanna lutea", "Anchusa arvensis")
  vcr::use_cassette("is_native", {
    aa <- is_native(sp[2], where = "Continental US", region = "america")
  })

  expect_is(aa, "data.frame")
  expect_equal(NROW(aa), 1)
  expect_named(aa)
  expect_equal(aa$name, "Carpobrotus edulis")
  expect_equal(aa$origin, "Introduced")
})
