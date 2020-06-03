test_that("griis", {
  skip_on_cran()

  vcr::use_cassette("griis", {
    aa <- griis(name = "Carpobrotus edulis")
  })

  expect_is(aa, "data.frame")
  expect_named(aa, c('Species', 'Authority', 'Country', 'Kingdom',
                     'Environment.System', 'Origin', 'Evidence.of.Impacts',
                     'Verified', 'Date', 'Source'))
})
