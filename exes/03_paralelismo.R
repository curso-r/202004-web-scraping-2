library(httr)
library(xml2)
library(future)
library(furrr)

# Estabelecer um plano de execução paralela com a função `plan()`. Entender a
# diferença entre todos os planos disponíveis.

plan(multisession, workers = 4)

#> - `sequential`: não executa em paralelo, útil para testes
#> - `multicore`: mais eficiente, não funciona no Windows nem dentro do RStudio
#> - `multisession`: abre novas sessões do R, mais pesado para o computador
#> - `multiprocess`: escolhe o melhor entre `multicore` e `multisession`
  
# Criar uma função que retorna o primeiro parágrafo de uma página da Wikipédia
# dado o fim de seu URL (como "/wiki/R\_language"). Dicas: textos são denotados
# pela _tag_ `<p>` em HTML; pule o elemento de classe "mw-empty-elt".

paragrafo_wiki <- function(url) {
  url %>%
    paste0("https://en.wikipedia.org", .) %>%
    read_html() %>%
    xml_find_first("//p[not(@class='mw-empty-elt')]") %>%
    xml_text()
}

# Executar a função anterior em paralelo para todos os links encontrados no
# exercício de iteração. Dicas: utilize `future_map()` do pacote `furrr`; não se
# esqueça do `possibly()`!

"https://en.wikipedia.org/wiki/R_language" %>%
  read_html() %>%
  xml_find_all("//table[@class='infobox vevent']//a") %>%
  xml_attr("href") %>%
  future_map(possibly(paragrafo_wiki, ""))

# Extra (com progresso)
maybe_get <- possibly(GET, NULL)
f <- function(url, caminho) {
  Sys.sleep(1) # Para ver a barra de progresso
  resultado <- maybe_get(url)
  
  if (!is.null(resultado)) {
    writeBin(content(resultado, "raw"), caminho)
  }
  
  return(TRUE)
}

caminhos <- paste0("arqs/wiki/", 1:length(urls), ".html")

"https://en.wikipedia.org/wiki/R_language" %>%
  read_html() %>%
  xml_find_all("//table[@class='infobox vevent']//a") %>%
  xml_attr("href") %>%
  paste0("https://en.wikipedia.org", .) %>%
  future_map2(caminhos, f, .progress = TRUE)

