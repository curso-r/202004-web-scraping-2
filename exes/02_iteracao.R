library(httr)
library(xml2)

# Na página da Wikipédia do R, encontrar o objeto correspondente à tabela
# lateral de informações. Pegar apenas os elementos correspondentes a links.

links <- "https://en.wikipedia.org/wiki/R_language" %>%
  read_html() %>%
  xml_find_all("//table[@class='infobox vevent']//a")

# Exatamente igual
"https://en.wikipedia.org/wiki/R_language" %>%
  read_html() %>%
  xml_find_all("//table[@class='infobox vevent']") %>%
  xml_find_all(".//a")

head(links)

# Extrair todos os URLs dos links e completá-los com o resto do caminho da
# Wikipédia. Continuar usando apenas _pipes_.

urls <- xml_attr(links, "href")
urls <- paste0("https://en.wikipedia.org", urls)

head(urls)

# Baixar todas as páginas da Wikipédia. Dicas: use `possibly()` para impedir erros
# quando o URL for inválido; procure saber sobre a função `map2()` para iterar em
# mais de uma lista; salve os arquivos com `GET(..., write_disk(path))`.

# 1
maybe_get <- possibly(GET, NULL)
map(urls, maybe_get)

# 2
paste0(basename(urls), ".html")

caminhos <- paste0("arqs/wiki/", 1:length(urls), ".html")

f <- function(url, caminho) {
  resultado <- maybe_get(url)
  
  if (!is.null(resultado)) {
    writeBin(content(resultado, "raw"), caminho)
  }
  
  return(TRUE)
}
resultado <- map2(urls, caminhos, f)

# Mesma coisa
map2(urls, caminhos, ~maybe_get(.x, write_disk(.y)))

# 2h depois
"arqs/wiki/15.html" %>%
  read_html() %>%
  xml_find_first("//h1") %>%
  xml_text()
