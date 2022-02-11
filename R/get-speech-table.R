#' Obtains the text of the speech
#'
#' @description
#'
#' Extract the text of the speech given an URL.
#'
#' @param keyword the keyword used to search speeches.
#' @param reference_date end date of search.
#' @param qtd_days quantity of days before the `reference_date`.
#' @param uf state acronym.
#' @param orador speaker's name.
#' @param partido political party of speaker.
#'
#' @return the speech data with all informational columns and the speech.
#'
#' @export
#'
#' @examples speech_data(keyword = '"meio ambiente"', reference_date = "2021-12-20", qtd_days = 3)
speech_data <- function(keyword,
                        reference_date,
                        qtd_days,
                        uf = "",
                        orador = "",
                        partido = "") {
  if (lubridate::ymd(reference_date) > lubridate::ymd("2021-12-31")) {
    rlang::abort("The website dont't make 2022 speeches available yet.")
  }

  first_page <- download_page(
    tx_text = keyword,
    current_page = 1,
    reference_date = reference_date,
    qtd_days = qtd_days,
    uf = uf,
    orador = orador,
    partido = partido
  )

  pages <-
    purrr::map(
      seq(1, num_pag(first_page)),
      ~ download_page(
        tx_text = keyword,
        current_page = .x,
        reference_date = reference_date,
        qtd_days = qtd_days,
        uf = uf,
        orador = orador,
        partido = partido
      )
    )

  maybe_get_speech_text <- purrr::possibly(get_speech_text,
    otherwise = "error"
  )

  texts <-
    purrr::map(
      pages,
      ~ transformer_url(.x)
    ) %>%
    unlist() %>%
    purrr::discard(. == "vazia") %>%
    purrr::map(~ maybe_get_speech_text(.x)) %>%
    unlist()

  maybe_extract_table <- purrr::possibly(extract_table,
    otherwise = tibble::tibble(error = "error")
  )
  tab <-
    purrr::map_dfr(
      pages,
      ~ maybe_extract_table(.x)
    ) %>%
    clean_table(texts)

  tab
}
