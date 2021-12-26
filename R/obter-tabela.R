
#' Obtém tabela dado um texto e a data
#'
#'@description
#'
#' Baixa primeira página da web, salvando em um arquivo html.
#'
#' @param tx_texto Texto presente no discurso
#' @param file Caminho para a salvar a página (deve ser html)
#' @param discurso String de texto obtido pelas funções auxiliares
#' @param current_page Página da pesquisa (números inteiros)
#' @param dt_inicio Data de início da pesquisa
#' @param dt_fim Data de fim da pesquisa
#' @return Invisível, retorna o response do GET dado
#'
#'@export
#'
baixa_pagina <- function(
  tx_texto, file, discurso,
  current_page = 1,
  dt_inicio = lubridate::today() - 100,
  dt_fim = lubridate::today()) {

  path <- stringr::str_glue("{file}{tx_texto}_{dt_inicio}_{dt_fim}_{current_page}.html")

  path <- path %>%
    stringr::str_remove_all('"') %>%
    stringr::str_replace_all(" ", "_")

  dt_inicio <- format(dt_inicio, "%d/%m/%Y")
  dt_fim <- format(dt_fim, "%d/%m/%Y")

  u_base <- "https://www.camara.leg.br/internet/sitaqweb/"
  u_tabela <- paste0(u_base, "resultadoPesquisaDiscursos.asp")

  query <- list(
    'CurrentPage' = current_page,
    'BasePesq'= 'plenario',
    'dtInicio'= dt_inicio,
    'dtFim'= dt_fim,
    'txUF'= '',
    'CampoOrdenacao' = 'dtSessao',
    'TipoOrdenacao'= 'DESC',
    'PageSize'= '50',
    'txTexto'= tx_texto
  )

  httr::GET(u_tabela, query = query,
            httr::write_disk(path, overwrite = TRUE))
}

# limpa a tabela
clean_tabela <- function(tab, txt){

  tab %>%
    janitor::clean_names() %>%
    dplyr::filter(dplyr::row_number() %% 2 != 0) %>%
    tidyr::separate(orador,
                    c("orador", "partido"),
                    sep = ",") %>%
    tidyr::separate(publicacao,
                    c("local_publicacao", "data_publicacao"),
                    sep = " ") %>%
    dplyr::mutate(
      dplyr::across(
        .cols = c(data, data_publicacao),
        .fns = lubridate::dmy
      ),
      discurso = txt
    ) %>%
    dplyr::select(-sumario)

}

# pega quantidade de paginas
num_pag <- function(r_html){
  r_html %>%
    xml2::read_html() %>%
    xml2::xml_find_first('//*[@id="content"]/div/span[3]') %>%
    xml2::xml_text() %>%
    str_replace("[.]", "") %>%
    as.integer + 1 %/% 50

}
