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
map(urls, possibly(GET, ...))

# 2
caminhos <- c("1.html", "2.html", ...) # paste0(1:10, ".html")

f <- function(url, caminho) {
  GET(url, write_disk(caminho))
}
map2(urls, caminhos_para_salvar, f)
