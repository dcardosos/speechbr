#' Obtains the HTML file of a current page given a main text or phrase.
#'
#' @description
#'
#' GET request of the pages of `DISCURSOS E NOTAS TAQUIGRÁFICAS` site given a main word or phrase and the dates.
#'
#' @param tx_text principal text or phrase present on speech.
#' @param current_page current page of search (integer numbers).
#' @param reference_date end date of search.
#' @param qtd_days quantity of days before the `reference_date`.
#' @param uf state acronym.
#' @param orador speaker's name.
#' @param partido political party of speaker.
#'
#' @return invisible, return a HTML file
#'
#' @noRd
download_page <- function(tx_text,
                          current_page,
                          reference_date,
                          qtd_days,
                          uf,
                          orador,
                          partido) {
  dt_fim <- format(lubridate::ymd(reference_date), "%d/%m/%Y")
  dt_inicio <- format(lubridate::ymd(reference_date) - qtd_days, "%d/%m/%Y")

  u_base <- "https://www.camara.leg.br/internet/sitaqweb/"
  u_tabela <- paste0(u_base, "resultadoPesquisaDiscursos.asp")

  query <- list(
    "CurrentPage" = current_page,
    "BasePesq" = "plenario",
    "dtInicio" = dt_inicio,
    "dtFim" = dt_fim,
    "txUF" = uf,
    "CampoOrdenacao" = "dtSessao",
    "TipoOrdenacao" = "DESC",
    "PageSize" = "50",
    "txTexto" = tx_text,
    "txOrador" = orador,
    "txPartido" = partido
  )

  r <- httr::GET(u_tabela, query = query)

  not_found <- r %>%
    xml2::read_html() %>%
    xml2::xml_find_first('//span[@class="labelInfo"]') %>%
    xml2::xml_text()

  if (!rlang::is_na(not_found)) {
    rlang::abort("No speeches found.")
  }

  return(r)
}

#' Get the table with informations
#'
#' @description
#'
#' Get the table as a tibble with the information
#'
#' @param r_html a response HTML file
#'
#' @return return the table with informations about the speaker
#'
#' @noRd
extract_table <- function(r_html) {
  r_html %>%
    xml2::read_html() %>%
    xml2::xml_find_first('//*[@id="content"]/div/table') %>%
    rvest::html_table()
}

#' Clean the table and add the text of the speechs
#'
#' @description
#'
#' Clean the columns names, exclude empty rows and separate columns.
#'
#' @param tab durty table
#' @param txt vector with the texts
#' @return return the cleaned table
#'
#' @noRd
clean_table <- function(tab, txt) {
  tab %>%
    janitor::clean_names() %>%
    dplyr::filter(dplyr::row_number() %% 2 != 0) %>%
    tidyr::separate(orador,
      c("orador", "partido"),
      sep = ","
    ) %>%
    dplyr::mutate(partido = stringr::str_squish(partido)) %>%
    tidyr::separate(partido,
     c("partido", "estado"),
     sep = "-") %>%
    dplyr::mutate(
      dplyr::across(
        .cols = c(data),
        .fns = lubridate::dmy
      ),
      discurso = txt
    ) %>%
    dplyr::select(-sumario)
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
num_pag <- function(r_html) {
  r_html %>%
    xml2::read_html() %>%
    xml2::xml_find_first('//*[@id="content"]/div/span[3]') %>%
    xml2::xml_text() %>%
    stringr::str_replace("[.]", "") %>%
    as.integer() %/% 50 + 1
}
