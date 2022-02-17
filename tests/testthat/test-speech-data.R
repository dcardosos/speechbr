
# TODO: aplicar a função em uma lista de inputs aleatórios

test_that("error with inappropriate `start_date` and `end_date`", {

  # test with `start_date` after 2021-12-31
  expect_error(speech_data("policia", "2022-01-01", "2022-02-01"))

  # test with `end_date` after 2021-12-31
  expect_error(speech_data("tecnologia", "2021-12-01", "2022-02-01"))

  # test with `start_date` greater that `end_date`
  expect_error(speech_data("CPI", "2021-08-05", "2021-05-01"))

})


test_that("error with data structure", {

  # test if there is no speeches in the date range searched
  expect_error(speech_data("pandemia", "2021-12-20", 2))

  # test if the number of columns is correct
  data <- speech_data("tecnologia", "2021-09-01", "2021-10-10")
  expect_equal(ncol(data), 9)

  # test if type is correct
  data <- speech_data("tecnologia", "2021-09-01", "2021-10-10", party = "PT")
  expect_s3_class(data, "tbl")

  # test if number of row is greater than 0
  data <- speech_data("tecnologia", "2021-09-01", "2021-10-10", party = "PT")
  expect_more_than(nrow(data), 0)

})





