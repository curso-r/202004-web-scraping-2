library(httr)
library(xml2)

# Acesse o site de buscas https://duckduckgo.com. Baixe a página de buscas. Dica:
# use a função `httr::GET()`.

GET("https://duckduckgo.com", write_disk("arqs/ddg.html"))
html <- read_html("arqs/ddg.html")

html <- content(GET("https://duckduckgo.com"))

# Examine o código-fonte da página para encontrar o elemento correspondente à
# caixa de busca e copie o seu XPath pelo navegador. Esse XPath é apropriado? Por
# que?

'//*[@id="search_form_input_homepage"]'

# Uma forma mais simples talvez fosse

'//input[@name="q"]'

# Examine a aba de rede do inspetor do seu navegador. Quando você faz uma busca,
# qual requisição corresponde à mesma? Reproduza essa requisição com o pacote
# `httr`. Dica: use o parâmetro `query` para enviar a requisição correta.

GET("https://duckduckgo.com", query = list(q = "texto", t = "h_"))
