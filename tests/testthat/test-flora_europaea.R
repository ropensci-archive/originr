test_that("flora_europaea", {
  skip_on_cran()

  sp <- c("Carpobrotus edulis", "Rosmarinus officinalis")
  vcr::use_cassette("flora_europaea", {
    aa <- flora_europaea(sp[1], messages = FALSE)
    bb <- flora_europaea(sp[2], messages = FALSE)
  })

  expect_is(aa, "list")
  expect_named(aa, c('native', 'exotic', 'status_doubtful', 'occurrence_doubtful', 'extinct'))
  expect_equal(aa$native, NA_character_)
  expect_is(aa$exotic, "character")

  expect_is(bb, "list")
  expect_named(bb, c('native', 'exotic', 'status_doubtful', 'occurrence_doubtful', 'extinct'))
  expect_equal(bb$occurrence_doubtful, NA_character_)
  expect_is(bb$exotic, "character")
})

test_that("flora_europaea fails well - species not found when searching GBIF", {
  skip_on_cran()

  sp <- "asdfadsf"
  vcr::use_cassette("flora_europaea_fail", {
    cc <- flora_europaea(sp, messages = FALSE)
  })
  expect_null(cc)
})
