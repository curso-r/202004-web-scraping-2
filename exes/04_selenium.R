library(httr)
library(xml2)
library(RSelenium)
library(webdriver)

pjs <- run_phantomjs()
ses <- Session$new(port = pjs$port)

# Encontrar a página de Fundos de Investimento da XP. Criar uma sessão `webdriver`
# para ir até esta página.

xp <- paste0(
  "https://institucional.xpi.com.br/investimentos/",
  "fundos-de-investimento",
  "/lista-de-fundos-de-investimento.aspx"
)
ses$go(xp)
ses$takeScreenshot()

# Fazer a sessão `webdriver` clicar na aba "Internacional" no topo da página.

elem <- ses$findElement(xpath = '//*[@id="TabPrimaria"]/li[2]/a')
elem$click()
ses$takeScreenshot()

# Filtrar apenas os fundos de alto risco. Dica: podemos selecionar um elemento de
# uma lista com as setas do teclado (analisar `key`) ou podemos obter a estrutura
# da lista de seleções.

elem <- ses$findElement(xpath = '//*[@id="tableReferenciadoRisk"]/span/select')
elem$click()

elem <- ses$findElement(xpath = '//*[@id="tableReferenciadoRisk"]/span/select/option[@value="5"]')
elem$click()

ses$takeScreenshot()

html <- ses$getSource()
readr::write_file(html, "arqs/xp_webdriver.html")

"arqs/xp_webdriver.html" %>%
  read_html() %>%
  xml_find_all("//table[@id='tableReferenciado']") %>%
  rvest::html_table() %>%
  purrr::pluck(1) %>%
  janitor::clean_names() %>%
  dplyr::as_tibble() %>%
  dplyr::pull(fundo)
