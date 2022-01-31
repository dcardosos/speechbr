
<!-- README.md is generated from README.Rmd. Please edit that file -->

# speechbr <img src="man/figures/hexlogo.png" align="right" width = "120px"/>

<!-- badges: start -->
<!-- badges: end -->

## Overview

The goal of `{speechbr}` is to democratize access to the speeches of the
deputies, that is, their ideias and thoughts.

The data is obtained on [Discursos e Notas
Taquigráficas](https://www2.camara.leg.br/atividade-legislativa/discursos-e-notas-taquigraficas)
of [Câmara dos Deputados](https://www.camara.leg.br/).

## Installation

You can install the development version of speechbr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dcardosos/speechbr")
```

## Example

An example of a base searching for the term “Bolsonaro”:

``` r
library(speechbr)
library(ggplot2)

tab <- speechbr::speech_data(
  keyword = "Bolsonaro",
  reference_date = "2021-12-25",
  qtd_days = 5)

dplyr::glimpse(tab)
#> Rows: 9
#> Columns: 10
#> $ data             <date> 2021-12-21, 2021-12-21, 2021-12-21, 2021-12-21, 2021…
#> $ sessao           <chr> "35.2021.N", "35.2021.N", "35.2021.N", "35.2021.N", "…
#> $ fase             <chr> "ORDEM DO DIA", "ORDEM DO DIA", "ORDEM DO DIA", "ORDE…
#> $ discurso         <chr> "O SR. KIM KATAGUIRI (DEM - SP. Pela ordem. Sem revis…
#> $ orador           <chr> "KIM KATAGUIRI", "VITOR HUGO", "REGINALDO LOPES", "GL…
#> $ partido          <chr> "DEM", "PSL", "PT", "PSOL", "PP", "PCDOB", "PT", "PT"…
#> $ estado           <chr> "SP", "GO", "MG", "RJ", "BA", "BA", "SP", "SP", "MG"
#> $ hora             <chr> "19h44", "19h32", "19h20", "19h12", "18h48", "18h44",…
#> $ local_publicacao <chr> "DCD", "DCD", "DCD", "DCD", "DCD", "DCD", "DCD", "DCD…
#> $ data_publicacao  <date> 2021-12-22, 2021-12-22, 2021-12-22, 2021-12-22, 2021-…
```

The others parameters are `partido` (political party), `orador`
(speaker’s name) and `uf` (state acronym). The default values of them
are *empty* (““).

A simple application using the base:

``` r
tab %>% 
  dplyr::group_by(partido) %>% 
  dplyr::count(partido) %>% 
  dplyr::ungroup() %>% 
  dplyr::top_n(10, n) %>%
  ggplot(aes(reorder(partido, -n), n)) +
  geom_bar(stat = "identity", fill = "#0066ff") +
  theme_minimal() +
  labs(
    title = "Quantity of speeches with that cited `Bolsonaro` per political party",
    subtitle = "Searched within 2021-12-25 and 2021-12-20", 
    x = "Party",
    y = "Quantity of speeches"
  )
```

<img src="man/figures/README-example_2-1.png" width="100%" />

### Example of a base

| data       | sessao    | fase         | discurso                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | orador        | partido | estado | hora  | local_publicacao | data_publicacao |
|:-----------|:----------|:-------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------|:--------|:-------|:------|:-----------------|:----------------|
| 2021-12-21 | 35.2021.N | ORDEM DO DIA | O SR. KIM KATAGUIRI (DEM - SP. Pela ordem. Sem revisão do orador.) - Sr. Presidente, Sras. e Srs. Deputados, Sras. e Srs. Senadores, lamento que o ano termine com este Parlamento chancelando o que o Governo de Jair Bolsonaro enviou para o Orçamento do ano que vem: previsão de fila para receber o Auxílio Brasil, para quem está na pobreza, para quem está na extrema pobreza, e de prioridade tanto para o orçamento do Fundo Eleitoral, para o pagamento de campanhas políticas, como também para o orçamento secreto. E sei também que muitos dos Parlamentares bolsonaristas votam agora contra o Orçamento, mas jogando para a plateia. É gente que vota contra aqui no plenário, mas depois, na campanha do ano que vem, vai pedir ao seu partido recursos, dinheiro, para fazer campanha. Pelo menos quem vota ‘sim’ nesta votação assume o ônus, assume que está a favor do aumento e não é hipócrita como parte daqueles que votam contra, fazem uma graça aqui em plenário, mas, depois, no ano que vem, vão pedir dinheiro público do Fundo Eleitoral para fazer suas campanhas. Eu me recusei a colocar a minha digital, o meu voto a favor de um Orçamento que prevê 13 vezes mais investimento em campanha eleitoral do que em saneamento básico - é mais importante comprar santinho, alugar caminhão de som, pagar a cabo eleitoral do que garantir acesso a banheiro e a água tratada para milhões de brasileiros. Há 1.167 vezes mais orçamento secreto do que gasto com habitação; mais do que com esporte, mais do que com cultura, mais do que com ciência e tecnologia, mais do que com meio ambiente, mais do que com energia. Diversos Parlamentares nesta Casa têm por bandeira a defesa do meio ambiente, têm por bandeira a defesa do setor energético, têm por bandeira a defesa da cultura, a defesa do esporte, mas, infelizmente, nós não vimos essa atuação tão efusiva na defesa do Orçamento. O Orçamento foi muito mais voltado para a campanha eleitoral e para o orçamento secreto, para o recebimento de dinheiro, de verba, para inaugurarem obra nos seus redutos eleitorais e permanecerem como base do Governo Bolsonaro e coligados com o Governo Bolsonaro. Enfim, haverá um gasto para que o Presidente da República mantenha a sua coligação no ano que vem maior do que com esporte, maior do que com ciência e tecnologia, que estão com as bolsas, como já foi bem colocado aqui, absolutamente sucateadas. E no orçamento secreto não há ideologia, não. Há petista recebendo recursos, há pedetista recebendo recursos; gente do Governo, gente da Oposição. Nessa hora, não há petismo, não há bolsonarismo, ambos votam com o mesmo interesse. Depois, a classe política, nós políticos não sabemos por que as ruas, por que a população tem cada vez menos apreço pela classe política. Ora, vejam as prioridades que nós estabelecemos no Orçamento! Eu peço mais 30 segundos para concluir, Presidente. Vejam as prioridades que esta Casa dá no Orçamento! Dá prioridade para campanha eleitoral, dá prioridade para orçamento secreto, em detrimento de áreas fundamentais para o nosso País, como a ciência e tecnologia, a habitação e o saneamento básico.Eu posso, no ano que vem, não receber nenhum centavo de dinheiro público para fazer minha campanha, mas faço e a farei com a consciência tranquila de que não vendi o meu voto, ou a minha alma, ou a minha convicção, em troca de financiamento público.Obrigado.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | KIM KATAGUIRI | DEM     | SP     | 19h44 | DCD              | 2021-12-22      |
| 2021-12-21 | 35.2021.N | ORDEM DO DIA | O SR. VITOR HUGO (PSL - GO. Pela ordem. Sem revisão do orador.) - Sr. Presidente, inicialmente eu queria parabenizar a Senadora Rose de Freitas pela Presidência da CMO e também o Deputado Hugo Leal pela condução dos trabalhos em relação à relatoria do Orçamento neste ano.Quero dizer da nossa felicidade por termos aprovado esta peça. Por isto o PSL votou a favor: porque sabemos da importância do Orçamento para o Brasil. A maioria do PSL, pelo menos, votou a favor.É claro que a nossa posição já ficou muito clara em relação ao aumento do Fundo Eleitoral quando da apreciação do veto do Presidente Bolsonaro em relação à LDO. Ali o PSL apresentou um destaque. V.Exa. concedeu a votação nominal já de ofício, até porque isso era regimental. Ali, cada Deputado e Senador pôde mostrar a sua posição sobre o fundo.O nosso combate continuou. Nós apresentamos aqui dois destaques, um requerimento de preferência e um destaque de preferência. Na avaliação da nossa Liderança, havia, sim, espaço regimental para isso. O Regimento é uma peça jurídica e nele cabem interpretações.Na nossa visão, o art. 132-A, que trata de apresentações genéricas de destaque, combinado com o art. 49, § 5º, que fala que, recaindo a preferência sobre o substitutivo - que era o caso -, poderão ser destacadas partes do projeto ou emendas, nós fizemos destaque de preferência para parte do projeto original. O Regimento Comum não fala que, para destaque de preferência para parte do projeto, tem que haver apoiamento.Essa foi a interpretação da nossa Liderança. Nós a apresentamos nesse sentido sem qualquer intenção diferente de que cada um pudesse aqui se manifestar, votar e demonstrar mais uma vez para todo o País qual é a sua posição.Essa foi a interpretação do PSL, mas eu quero esclarecer também à Nação que essa posição já ficou evidente na votação do veto. Ali cada um já pôde expressar sua posição.Quero também aqui, Presidente, dizer que não houve, na sua fala - eu vou me retratar com V.Exa. -, nenhuma expressão de leviandade ou de deslealdade daí da Mesa, embora tenha havido uma fala dizendo que certamente era da minha ciência que os destaques apresentados pelo PSL seriam descabidos, o que eu reforço que não eram. Não tinha como saber da interpretação da Mesa em relação a isso; inclusive, várias outras Lideranças se manifestaram no sentido de que eram, sim, cabidos os destaques.Feita essa ressalva, eu quero dizer que nós votamos a favor do Orçamento como um todo porque esse pequeno detalhe, que já havia sido decidido na derrubada do veto, certamente não vai ofuscar todo o trabalho que o Parlamento fez em relação à distribuição de recursos para os mais diversos rincões do nosso País, para cuidar da educação, da saúde, da segurança e de outros temas.Muito obrigado, Presidente.O SR. PRESIDENTE (Marcelo Ramos. PL - AM) - Obrigado.Deputado Vitor Hugo, eu faço questão de fazer um esclarecimento a V.Exa.Esse é um debate muito contaminado por um episódio que aconteceu algumas sessões atrás, também relacionado ao Fundo Eleitoral. Talvez a contaminação daquele episódio tenha também contaminado o julgamento que eu fiz do requerimento apresentado por V.Exa.A Mesa tem uma interpretação absolutamente clara, e com a qual eu concordo, que está fundada no art. 132, que diz:Art. 132. O parecer da CMO sobre as emendas à receita e à despesa será conclusivo e final, salvo requerimento para que emenda seja submetida a votos, assinado por 1/10 (um décimo) dos congressistas e apresentado à Mesa do Congresso Nacional até o início da ordem do dia da sessão do Congresso Nacional.Além disso, o art. 139, inciso II, estabelece:Art. 139. Ressalvados os casos específicos previstos nesta Resolução, somente será admitido destaque:…………………………………………………………………………………II - ao substitutivo - como era o caso -, para supressão de dispositivo ou parte de dispositivo;Então, nós temos a mais absoluta clareza de que o requerimento era indevido. No entanto, quando nós recebemos o requerimento da Mesa, a minha primeira palavra à Secretaria-Geral da Mesa foi que eu o colocaria em votação, a despeito do entendimento de que ele não cabia no disposto no art. 139, inciso II. Fui alertado pela Mesa de que ele teria inadequação formal que abriria um precedente gravíssimo, porque, na hora em que eu permitisse, nesse episódio, a votação de um destaque sem um décimo de apoiamento, estaria permitindo para todos os episódios, e o nosso Regimento viraria letra morta.Mas eu quero aqui considerar verdadeiramente como uma diferença de interpretação, e quero também, no limite do que eu disse, em público, na Mesa, fazer meu pedido de desculpas a V.Exa. No grupo, já conversamos pessoalmente e nos entendemos. Eu até posso ter um julgamento político, não da conduta de V.Exa., mas não cabe fazê-lo no exercício da Presidência da Casa, e por isso não vou me abster de fazer qualquer comentário em relação à fala do Deputado Glauber. Mas, em relação à conduta pessoal de V.Exa., eu quero aqui admitir que não houve nenhuma tentativa de manipulação da votação.Eu tenho procurado, no exercício da Presidência, ser sempre absolutamente leal, transparente com os colegas, e cumprir o que determina o Regimento.Se porventura ficou algum mal-entendido, eu renovo o pedido de desculpas a V.Exa., reafirmando a clareza da interpretação da Mesa, que é a clareza da interpretação da grande maioria dos Deputados, de que faltou o apoiamento. E, mesmo o Regimento estabelecendo que esse apoiamento tem que estar acompanhado do pedido de destaque já no início da sessão, eu ainda deferi o tempo do início da sessão até o momento da votação do destaque, para que, se por acaso fossem alcançadas as 60 assinaturas, nós colocássemos o requerimento em votação.Mas acho que esse é um episódio superado, o Brasil é muito maior do que essas diferenças que porventura nós tenhamos em algum momento. | VITOR HUGO    | PSL     | GO     | 19h32 | DCD              | 2021-12-22      |
