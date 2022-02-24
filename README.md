
<!-- README.md is generated from README.Rmd. Please edit that file -->

# speechbr <img src="man/figures/hexlogo.png" align="right" width = "120px"/>

<!-- badges: start -->
[![](https://cranlogs.r-pkg.org/badges/speechbr)](https://cran.r-project.org/package=speechbr)
<!-- badges: end -->

## Overview

The goal of `{speechbr}` is to democratize access to the speeches of the
deputies, that is, their ideias and thoughts.

The data is obtained on [Discursos e Notas
Taquigráficas](https://www2.camara.leg.br/atividade-legislativa/discursos-e-notas-taquigraficas)
of [Câmara dos Deputados](https://www.camara.leg.br/).

## Observation

The released version from CRAN is limited to speeches before 2022. For access speeches after 2021-12-31, use the development version.

## Installation

You can install the released version of `{speechbr}` from [CRAN](https://cran.r-project.org/) with:

``` r
install.packages("speechbr")
```

You can install the development version of `{speechbr}` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dcardosos/speechbr")
```

## Example

An example of a base searching for the term “tecnologia” between
2021-09-01 and 2021-10-01:

``` r
library(speechbr)

tab <- speechbr::speech_data(
  keyword = "tecnologia",
  start_date = "2021-09-01", 
  end_date = "2021-10-01")

dplyr::glimpse(tab)
#> Rows: 59
#> Columns: 9
#> $ data       <date> 2021-10-01, 2021-09-30, 2021-09-30, 2021-09-30, 2021-09-29…
#> $ sessao     <chr> "86.2021.B", "85.2021.B", "85.2021.B", "85.2021.B", "112.20…
#> $ fase       <chr> "BREVES COMUNICAÇÕES", "BREVES COMUNICAÇÕES", "BREVES COMUN…
#> $ discurso   <chr> "O SR. RUBENS BUENO (CIDADANIA - PR. Sem revisão do orador.…
#> $ orador     <chr> "RUBENS BUENO", "BIBO NUNES", "SIDNEY LEITE", "BOHN GASS", …
#> $ partido    <chr> "CIDADANIA", "PSL", "PSD", "PT", "NOVO", "PODE", "REDE", "S…
#> $ estado     <chr> "PR", "RS", "AM", "RS", "RJ", "RO", "RR", "TO", "RJ", "CE",…
#> $ hora       <chr> "9h16", "10h44", "10h24", "10h12", "18h04", "18h04", "18h04…
#> $ publicacao <chr> "DCD 02/10/2021", "DCD 01/10/2021", "DCD 01/10/2021", "DCD …
```

The others parameters are `party` (political party), `speaker`
(speaker’s name) and `uf` (state acronym). Their default values are
*empty* (““).

A simple application using the base, a wordcloud:

``` r
# install.package("wordlcoud2")
# install.package("tidytext")

stop_words <- tidytext::get_stopwords("pt")

others_words <- c("nao", "ter", "termos", "r", "fls", "sr", "ja", "sao",
                  "porque", "aqui","ha", "ser", "ano", "presidente", "tambem")

tab %>%
  tibble::rowid_to_column("id") %>%
  dplyr::select(id, discurso) %>%
  tidytext::unnest_tokens(word, discurso) %>%
  dplyr::filter(!grepl('[0-9]', word)) %>%
  dplyr::mutate(word = abjutils::rm_accent(word)) %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::group_by(word) %>%
  dplyr::count(word, sort = TRUE) %>%
  dplyr::filter(n > 5, !word %in% others_words) %>% 
  wordcloud2::wordcloud2()
```

<img src="man/figures/wordcloud.png" width="100%"/>

### Example of a base

| data       | sessao    | fase                | discurso                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | orador       | partido   | estado | hora  | publicacao     |
|:-----------|:----------|:--------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------|:----------|:-------|:------|:---------------|
| 2021-10-01 | 86.2021.B | BREVES COMUNICAÇÕES | O SR. RUBENS BUENO (CIDADANIA - PR. Sem revisão do orador.) - Sr. Presidente Eduardo Bismarck, Sras. e Srs. Deputados, a Organização das Nações Unidas - ONU divulgou, em 29 de setembro, o relatório COVID-19 e Desenvolvimento Sustentável: avaliando a crise de olho na recuperação, de 2021, no qual sugere ações para a recuperação do Brasil diante dos prejuízos gerados pela pandemia.O relatório propõe o cumprimento de metas que fazem parte dos Objetivos de Desenvolvimento Sustentável da ONU e destaca que somente uma ação múltipla, com atenção especial voltada para o sistema público de saúde, para o crescimento econômico e para a redução das desigualdades, será capaz de retirar o Brasil do atual momento de dificuldades. Foram realizadas análises nas áreas de distribuição de renda, combate à fome, sustentabilidade e preservação do meio ambiente, igualdade de gênero e saúde. Com base nelas, a ONU sugeriu 55 ações, que objetivam a recuperação do País e a melhoria das condições de vida da população brasileira.O estudo é resultado do trabalho de especialistas do PNUD, da UNESCO, do UNICEF e da OPAS no acompanhamento de políticas de melhorias para o Brasil. O levantamento avaliou 94 indicadores de vulnerabilidade e de capacidade de resposta à pandemia, a partir dos quais estabelece as condições para o Brasil superar os impactos da pandemia, de maneira consistente e homogênea.Segundo a especialista Katyna Argueta, representante do PNUD no Brasil, embora o Brasil tenha registrado importantes progressos no desenvolvimento humano nas últimas décadas, a pandemia se sobrepôs às tensões não resolvidas entre os que têm acesso e oportunidade e os que não têm. Para ela, isso torna mais evidentes as diferenças de acesso dos brasileiros a importantes recursos, como serviços de saúde, educação, proteção social, emprego digno e renda, assim como redes de tecnologia. Entre as metas propostas estão investimentos industriais com externalidades ambientais positivas; política ativa de fomento à economia circular; universalização da banda larga; mecanismos para identificar e aprimorar o investimento público em políticas e programas para crianças e adolescentes; reforma tributária; mecanismos de governança compartilhados entre os Poderes; investimentos em creches e na pré-escola; e aprimoramento da economia digital.Destaco que foi elaborado um capítulo específico para a área da educação, em que foi demonstrado que os impactos para crianças e adolescentes podem perdurar. Neste sentido, o estudo ressalta a importância da priorização da reabertura de escolas com segurança e a necessidade de que todas as crianças e adolescentes sejam conectados à Internet até 2030.Conforme consta do relatório, 5,5 milhões de crianças e adolescentes tiveram o direito à educação negado em 2020. ‘Se no início da pandemia não foram consideradas como grupos de risco direto, são elas, de fato, as vítimas ocultas da COVID-19’, diz o relatório.Foi destacado também que, sem deixar de lado as medidas essenciais para conter a propagação do novo coronavírus, é preciso ter clareza sobre os impactos do fechamento de escolas por um tão longo período de aprendizagem na nutrição, uma vez que muitos dependem da merenda escolar, e na segurança de crianças e adolescentes, em especial os mais vulneráveis. Outro desafio destacado é o acesso desigual à tecnologia, que pode provocar o aumento da taxa de abandono escolar, trabalho infantil e gravidez na adolescência.Conforme consta do texto, com o fechamento massivo de estabelecimentos escolares, o ensino remoto mediado por tecnologias apresenta-se como alternativa para a continuidade da aprendizagem. Cabe-nos destacar que no Brasil 28% das famílias não têm acesso à Internet, percentual que aumenta conforme a renda diminui e chega a 48% nas áreas rurais.Como políticas sugeridas pelos pesquisadores, foram destacados a reabertura das escolas com segurança sanitária, o estabelecimento de parcerias para a inclusão digital, a manutenção do serviço de saúde, além da criação de oportunidade de trabalho para jovens entre 14 e 24 anos. Sem uma ação coordenada para prevenir, mitigar e responder aos efeitos da pandemia, as consequências para esse segmento agora e para a sociedade como um todo no futuro serão graves.Eu trouxe estas informações, Sr. Presidente, para entendermos que os Governos Federal, Estaduais e Municipais devem tomar conhecimento, com profundidade, das 55 ações propostas pela ONU, no intuito de reverter os danosos efeitos gerados à sociedade brasileira pela pandemia da COVID-19.Muito obrigado. | RUBENS BUENO | CIDADANIA | PR     | 9h16  | DCD 02/10/2021 |
| 2021-09-30 | 85.2021.B | BREVES COMUNICAÇÕES | O SR. BIBO NUNES (PSL - RS. Sem revisão do orador.) - Grato, digníssima Presidente Rosangela Gomes.Nobres colegas, é uma honra estar aqui neste ringue para lutar pelo Brasil. Estou muito feliz, porque acabo de chegar da base aérea da FAB, onde conhecemos o Gripen. São 36 aviões que o Brasil recebeu e que estarão fortalecendo ainda mais a nossa Força Aérea.O Gripen fará com que o Brasil fique entre as maiores tecnologias do mundo. Um terço do Gripen será de tecnologia brasileira, sendo que o seu painel é desenvolvido na empresa AEL, empresa israelense com sede no Rio Grande do Sul. E devido à alta tecnologia da AEL todo Gripen no mundo está usando o painel gaúcho da AEL, o que é motivo de grande orgulho. E perguntam: ‘Mas como fica o Gripen perante um Sukhoi um MiG ou um F-22?’ Certamente, chega muito próximo, mas vai atender todas as necessidades do Brasil. Estou muito orgulhoso com a nossa Força Aérea e também conheci o KC-390 que é brasileiro fabricado pela EMBRAER com muito mais tecnologia do que o Hércules, aquele avião norte-americano. Fico mais feliz ainda porque eu fui - em tom de brincadeira - o primeiro Parlamentar a sentar num Gripen e, logo após, foi o Deputado General Peternelli, que é das Forças Armadas. Mas como civil fiquei muito honrado de estar ali simulando pilotar um Gripen que vai fazer com que os demais países saibam que a defesa brasileira está cada dia mais forte. Estamos nos fortalecendo porque temos que demonstrar que temos força. ‘Se queres a paz, prepara-te para a guerra’.As nossas Forças Armadas neste Governo estão tendo muito apoio, assim como damos apoio à polícia, porque antigamente quem recebia força, infelizmente, era a bandidagem. Quando um policial matava ou feria um bandido era processado e tinha que responder a inquéritos e por aí afora. Hoje vivemos num novo Brasil, um Brasil que respeita a família, respeita o cidadão de bem, e agora, com muito orgulho, temos ainda a nossa Força Aérea recebendo 36 aviões F-39 Gripen. Encerro agradecendo e, com muito orgulho, vestindo o boné das Forças Armadas e do Gripen brasileiro.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | BIBO NUNES   | PSL       | RS     | 10h44 | DCD 01/10/2021 |

## How to cite

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5921104.svg)](https://doi.org/10.5281/zenodo.5921104)
