library(httr)
library(xml2)

# Na página da Wikipédia, encontrar o objeto correspondente à tabela lateral de
# informações. Pegar apenas os elementos correspondentes a links.

links <- "https://en.wikipedia.org/wiki/R_language" %>%
  read_html() %>%
  xml_find_all("//table[@class='infobox vevent']//a")

head(links)

# Extrair todos os URLs dos links e completá-los com o resto do caminho da
# Wikipédia. Continuar usando apenas _pipes_.

urls <- "https://en.wikipedia.org/wiki/R_language" %>%
  read_html() %>%
  xml_find_all("//table[@class='infobox vevent']//a") %>%
  xml_attr("href") %>%
  paste0("https://en.wikipedia.org", .)

head(urls)

# Baixar todas as páginas da Wikipédia. Dicas: use `possibly()` para impedir erros
# quando o URL for inválido; procure saber sobre a função `map2()` para iterar em
# mais de uma lista; salve os arquivos com `GET(..., write_disk(path))`.
