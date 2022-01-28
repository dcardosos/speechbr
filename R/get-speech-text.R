#'
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
#' @importFrom stringr str_remove str_remove_all str_replace_all str_trim str_squish
#' @importFrom xml2 read_html xml_find_first xml_text
#' @importFrom abjutils rm_accent
#'
#' @keywords internal
#'
get_speech_text <- function(txt_urls){

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

#'
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
#' @importFrom stringr str_replace_all str_squish
#' @importFrom xml2 read_html xml_find_all xml_attr
#' @importFrom stats na.omit

#' @keywords internal
#'

transformer_url <- function(r_html){

  u_base <- "https://www.camara.leg.br/internet/sitaqweb/"

  r_html %>%
    xml2::read_html() %>%
    xml2::xml_find_all('//*[@id="content"]/div/table/tbody/tr/td/a') %>%
    xml2::xml_attr("href") %>%
    stringr::str_squish() %>%
    stringr::str_replace_all(" ", "") %>%
    na.omit() %>%
    as.character() %>%
    paste0(u_base, .)
}
