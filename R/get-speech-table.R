#'
#' Obtains the text of the speech
#'
#' @description
#'
#' Extract the text of the speech given an URL.
#'
#' @param keyword argument of the `download_page` function.
#' @param reference_date end date of search, the default is the last day of 2021.
#' @param qtd_days quantity of days before the `reference_date`, the default is 5 days.
#'
#' @return vector the speech data with all informational columns and the speech.
#'
#' @importFrom purrr map possibly map_dfr
#' @importFrom tibble tibble
#' @importFrom rlang abort
#' @importFrom lubridate ymd
#' @export
#'
#' @examples speech_data(keyword = "pandemia", reference_date = "2021-12-20", qtd_days = 5)
#' @examples speech_data(keyword = '"meio ambiente"', reference_date = "2021-12-20", qtd_days = 5)
#'

speech_data <- function(
  keyword,
  reference_date,
  qtd_days){

  if(lubridate::ymd(reference_date) > lubridate::ymd("2021-12-31")){

    rlang::abort("The website dont't make 2022 speeches available yet.")

  }

  first_page <- download_page(tx_text = keyword,
                              current_page = 1,
                              reference_date = reference_date,
                              qtd_days = qtd_days)

  pages <-
    purrr::map(
      seq(1, num_pag(first_page)),
        ~ download_page(tx_text = keyword,
                        current_page = .x,
                        reference_date = reference_date,
                        qtd_days = qtd_days))

  maybe_get_speech_text <- purrr::possibly(get_speech_text,
                                           otherwise = "error")

  texts <-
    purrr::map(pages,
               ~ transformer_url(.x)) %>%
    unlist() %>%
    purrr::map(~ maybe_get_speech_text(.x)) %>%
    unlist()

  maybe_extract_table <- purrr::possibly(extract_table,
                                      otherwise = tibble::tibble(error = "error"))
  tab <-
    purrr::map_dfr(pages,
                   ~ maybe_extract_table(.x)) %>%
    clean_table(texts)

  tab

}
