#' Title
#'
#' @param tab
#' @param txt
#'
#' @return
#' @export
#'
#' @examples
#'
#'

get_table <- function(word, textos){

  primeiros_50 <- baixa_pagina(word)

  future::plan(multisession)
  progressr::with_progress({

    p <- progressr::progressor(num_pag(primeiros_50))

    pages <-
      furrr::future_map(seq(2, num_pag(primeiros_50)), ~{
        p()
        baixa_pagina(word, .x)
      })

  })

  pagina <- purrr::map(.x = seq(2, num_pag),
                       .f = ~ baixa_pagina(word, current_page = .x))

  textos <-
    pagina %>%
    get_url_texto() %>%
    maybe_get_texto_progress()

  tab <-
    pagina %>%
    get_tabela() %>%
    tabela_tidy(textos)


  tab

}
