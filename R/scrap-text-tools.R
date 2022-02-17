#' Obtains the text of the speech
#'
#' @description
#'
#' Extract the text of the speech given an URL
#'
#' @param r_html a response HTML file
#'
#' @return a transformed URL
#'
#' @noRd

shift_url <- function(r_html) {

  u_base <- "https://www.camara.leg.br/internet/sitaqweb/"

  # validate if the page have available transcribed speeches
  found_href <- r_html %>%
    xml2::read_html() %>%
    xml2::xml_find_all('//*[@id="content"]//table//a')

  if (length(found_href) > 0) {

    paste0(
      u_base,
      found_href %>%
        xml2::xml_attr("href") %>%
        stats::na.omit() %>%
        as.character() %>%
        purrr::keep(~ nchar(.x) >= 250) %>%
        stringr::str_squish() %>%
        stringr::str_replace_all(" ", "") %>%
        stringr::str_remove_all("--"))

  } else {

    return("empty")

  }


}

#' Obtains the text of the speech
#'
#' @description
#'
#' Extract the text of the speech given an URL
#'
#' @param txt_urls URL's to read HTML
#'
#' @return vector of text
#'
#'
#' @noRd
#'

extract_speech <- function(txt_urls){

  txt_urls %>%
    stringr::str_remove("(?<=txTipoSessao=).+?(?=&)") %>%
    abjutils::rm_accent() %>%
    xml2::read_html(options = "HUGE") %>%
    xml2::xml_find_first("/html/body/p") %>%
    xml2::xml_text() %>%
    stringr::str_squish() %>%
    stringr::str_trim() %>%
    stringr::str_replace_all("\"", "'") %>%
    stringr::str_remove_all("(Desligamento autom\u00e1tico do microfone.)")

}

# #' Some cleaning on text
# #'
# #' @description
# #'
# #' Clean some pattern and useless things in the text
# #'
# #' @param tab a tibble with a text column
# #' @param tx_column the text column
# #'
# #' @return vector of text
# #'
# #' @export
# #'
#
# parse_text <- function(tab, tx_column) {
#
# }
