#'
#' Obtains the text of the speech
#'
#' @description
#'
#' Extract the text of the speech given an URL.
#'
#' @param keyword argument of the `download_page` function.
#'
#' @return vector the speech data with all informational columns and the speech.
#'
#' @importFrom purrr map possibly map_dfr
#' @importFrom tibble tibble
#'
#' @export
#'
#' @examples speech_data(keyword = "pandemia")
#' @examples speech_data(keyword = '"meio ambiente"')
#'

speech_data <- function(keyword){

  first_page <- download_page(keyword)

  pages <-
    purrr::map(
      seq(1, num_pag(first_page)),
        ~ download_page(keyword, .x))

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
