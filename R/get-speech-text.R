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
get_speech_text <- function(txt_urls) {
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
transformer_url <- function(r_html) {
  u_base <- "https://www.camara.leg.br/internet/sitaqweb/"

  r_html %>%
    xml2::read_html() %>%
    xml2::xml_find_all('//*[@id="content"]/div/table/tbody/tr/td/a') %>%
    xml2::xml_attr("href") %>%
    purrr::discard(. == "#") %>%
    stringr::str_squish() %>%
    stringr::str_replace_all(" ", "") %>%
    stats::na.omit() %>%
    as.character() %>%
    paste0(u_base, .)
}
