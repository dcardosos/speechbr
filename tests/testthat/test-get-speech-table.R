test_that("limit of `reference_date` works", {

  # test with `reference_date` after 2021-12-31
  expect_error(speech_data("pandemia", "2022-01-01", 5))

  # test if there is no speeches in the date range searched
  expect_error(speech_data("pandemia", "2021-12-20", 2))

  # test if the number of columns is correct
  data <- speech_data("Bolsonaro", "2021-12-25", 5)
  expect_equal(ncol(data), 9)

  # test if type is correct
  data <- speech_data("Bolsonaro", "2021-12-25", 5, partido = "PT")
  expect_type(data, "list")

})
