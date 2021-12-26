
#' Obtém o texto do discurso dada as URLs
#'
#'@description Obtém e limpa o texto dos discursos
#'
#'@param txt_urls urls obtidas pela função `baixa_pagina`
#'
#'@return String grande
#'
#'
#'
get_texto <- function(txt_urls){

  txt_urls %>%
    stringr::str_remove("(?<=txTipoSessao=).+?(?=&)") %>%
    abjutils::rm_accent() %>%
    xml2::read_html(options = "HUGE") %>%
    xml2::xml_find_first("/html/body/p") %>%
    xml2::xml_text() %>%
    stringr::str_squish() %>%
    stringr::str_trim() %>%
    stringr::str_replace_all("\"", "'") %>%
    stringr::str_remove_all("(Desligamento automático do microfone.)")
}

# função auxiliar - obtem url do texto
obtem_url_texto <- function(r_html){

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


# pega os textos
maybe_get_texto <- purrr::possibly(get_texto, otherwise = "erro")

purrr::map_chr(u_texto, maybe_get_texto(.x))

