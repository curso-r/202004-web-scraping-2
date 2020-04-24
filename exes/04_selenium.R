library(httr)
library(xml2)
library(RSelenium)
library(webdriver)

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

elem <- ses$findElement(xpath = '//a[@href="#referenciado"]')
elem$click()
ses$takeScreenshot()

# Filtrar apenas os fundos de alto risco. Dica: podemos selecionar um elemento de
# uma lista com as setas do teclado (analisar `key`) ou podemos obter a estrutura
# da lista de seleções.
