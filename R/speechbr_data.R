#' Obtains the text of the speech
#'
#' @description
#'
#' Extract the text of the speech given an URL.
#'
#' @param keyword principal text or phrase present on speech.
#' @param start_date start date of search.
#' @param end_date end date of search.
#' @param uf state acronym.
#' @param speaker speaker's name.
#' @param party political party of speaker.
#'
#' @return the speech data with all informational columns and the speech.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#'  tecnologia_speeches <- speech_data(
#'    keyword = "tecnologia",
#'    reference_date = "2021-12-20",
#'    start_date = "2021-12-10",
#'    end_date = "2021-12-31")
#'
#'}

# TODO: error para start_date > end_date

speech_data <- function(
  keyword,
  start_date,
  end_date,
  uf = "",
  speaker = "",
  party = "") {


  if (lubridate::ymd(start_date) > lubridate::ymd(end_date)) {

    rlang::abort("`start_date` can't be greater than `end_date`.")

  }

  # extract html pages
  partial_build_url <- purrr::partial(
    build_url,
    keyword = keyword,
    start_date = start_date,
    end_date = end_date,
    uf = uf,
    speaker = speaker,
    party = party)

  first_page <- partial_build_url(current_page = 1) %>%
    speechbr_api()

  pages <-
    purrr::map(
      seq(1, parse_pagination(first_page)),
      ~ partial_build_url(current_page = .x)) %>%
    purrr::map(~ speechbr_api(.x))

  # extract the text speeches
  maybe_extract_speech <- purrr::possibly(extract_speech, otherwise = "error")

  texts <-
    purrr::map(
      pages,
      ~ shift_url(.x)) %>%
    unlist() %>%
    purrr::discard(~ .x == "empty") %>%
    purrr::map(~ maybe_extract_speech(.x)) %>%
    unlist()

  # extract table
  maybe_extract_table <- purrr::possibly(
    extract_table,
    otherwise = tibble::tibble(error = "error"))

  purrr::map_dfr(
      pages,
      ~ maybe_extract_table(.x)) %>%
    tidy_cleaner(texts)

}
