#' Build the url API
#'
#' @description
#'
#' Build the url API to request
#'
#' @param keyword principal text or phrase present on speech.
#' @param current_page current page of search (integer numbers).
#' @param start_date start date of search.
#' @param end_date end date of search.
#' @param uf state acronym.
#' @param speaker speaker's name.
#' @param party political party of speaker.
#'
#' @return invisible, return a list with the base url and the query
#'
#' @noRd

build_url <- function(
  keyword,
  current_page,
  start_date,
  end_date,
  uf = "",
  speaker = "",
  party = "") {

  u_base <- "https://www.camara.leg.br/internet/sitaqweb/resultadoPesquisaDiscursos.asp"

  query <- list(
    "CurrentPage" = current_page,
    "BasePesq" = "plenario",
    "dtInicio" = format(lubridate::ymd(start_date), "%d/%m/%Y"),
    "dtFim" = format(lubridate::ymd(end_date), "%d/%m/%Y"),
    "txUF" = uf,
    "CampoOrdenacao" = "dtSessao",
    "TipoOrdenacao" = "DESC",
    "PageSize" = "50",
    "txTexto" = keyword,
    "txOrador" = speaker,
    "txPartido" = party
  )

  # just fancy return
  # cat("<",u_base,">\n")
  # str(query)

  invisible(list("url" = u_base, "data" = query))

}

#' Obtains the HTML file of a current page given a main text or phrase.
#'
#' @description
#'
#' GET request of the pages of site given a list with the url and the query.
#'
#' @param builded_url list, principal text or phrase present on speech.
#'
#' @return invisible, return a response with HTML table or an abort
#'
#' @noRd

speechbr_api <- function(builded_url) {

  resp <- httr::GET(builded_url$url, query = builded_url$data)

  not_found <- resp %>%
    xml2::read_html() %>%
    xml2::xml_find_first('//span[@class="labelInfo"]') %>%
    xml2::xml_text()

  if (!rlang::is_na(not_found)) {

    rlang::abort("No speeches found.")

  }

  invisible(resp)
}

#' Get the table with informations
#'
#' @description
#'
#' Get the table as a tibble with the information
#'
#' @param r_html a response HTML file
#'
#' @return return the table with information about the speaker
#'
#' @noRd
#'

extract_table <- function(r_html) {

  r_html %>%
    xml2::read_html() %>%
    xml2::xml_find_first('//*[@id="content"]//table') %>%
    rvest::html_table()

}

#' Clean the table and add the text of the speeches
#'
#' @description
#'
#' Clean the columns names, exclude empty rows and separate columns.
#'
#' @param tab no tidy table
#' @param txt vector with texts
#'
#' @return return the cleaned table
#'
#' @importFrom rlang .data
#'
#' @noRd

tidy_cleaner <- function(tab, txt) {

  suppressWarnings({
    tab %>%
      janitor::clean_names() %>%
      dplyr::filter(dplyr::row_number() %% 2 != 0) %>%
      tidyr::separate(
        .data$orador,
        c("orador", "partido"),
        sep = ",") %>%
      dplyr::mutate(partido = stringr::str_squish(.data$partido)) %>%
      tidyr::separate(
        .data$partido,
        c("partido", "estado"),
        sep = "-") %>%
      dplyr::filter(.data$sessao != "") %>%
      dplyr::mutate(
        discurso = txt,
        data = lubridate::dmy(.data$data)) %>%
      dplyr::select(-.data$sumario)
  })

}

#' Calculate the number of pages that the request has.
#'
#' @description
#'
#' Extract the number of pages and calculate the specif number of pages for avoid future errors.
#'
#' @param r_html a response HTML file
#' @return return the number of pages that exist
#'
#' @noRd

parse_pagination <- function(r_html) {

  num_documents  <- r_html %>%
    xml2::read_html() %>%
    xml2::xml_find_first('//*[@id="content"]/div/span[3]') %>%
    xml2::xml_text() %>%
    stringr::str_replace("[.]", "") %>%
    as.integer()

  if (num_documents %% 50 == 0) {

    return(num_documents %/% 50)

  } else {

    return(num_documents %/% 50 + 1)

  }

}
