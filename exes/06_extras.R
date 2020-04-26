library(xml2)
library(httr)
library(purrr)

# Funções principais
html <- read_html("docs/static/html_exemplo.html")
nodes <- xml_find_all(html, "//p")
xml_text(nodes)
xml_attrs(nodes)

# xml_attrs -> todos os atributos
# xml_attr  -> um atributo com nome

# Diferença entre // e /
xml_find_all(html, "/html/body/p")
xml_find_all(html, "//p")

# Parentesco
xml_parent(nodes)
xml_parents(nodes)

# * ou tag
html <- read_html("docs/static/html_exemplo_css_a_parte.html")
xml_find_all(html, "//*[@class='azul']")
xml_find_all(html, "//p[@class='azul']")


# Possibly com map
maybe_read_html <- possibly(read_html, NULL)

read_html("https://errado.que")
maybe_read_html("https://errado.que")

urls <- c(
  "https://en.wikipedia.org/wiki/R_language",
  "https://en.wikipedia.org/wiki/Python_(programming_language)",
  "https://errado.que"
)

map(urls, maybe_read_html)

# Paralelo (CORRIGIDO)
library(parallel)
library(microbenchmark)

f <- function(x) {
  Sys.sleep(1)
  TRUE
}

microbenchmark(times = 1,
               seq = map_dbl(1:10, f),
               par = mclapply(1:10, f)
)

# XP
GET("https://institucional.xpi.com.br/investimentos/fundos-de-investimento/lista-de-fundos-de-investimento.aspx", write_disk("arqs/xp.html"))

# PhantomJS
library(webdriver)
pjs <- run_phantomjs()
ses <- Session$new(port = pjs$port)

ses$go("https://google.com")
ses$takeScreenshot()

# ses$findElement(...) # find_first
# ses$findElements(...) # find_all

elem <- ses$findElement(xpath = "//*[@name='q']")
elem$sendKeys("busca")
ses$takeScreenshot()

elem$sendKeys(key$enter)
ses$takeScreenshot()

html <- ses$getSource()
readr::write_file(html, "arqs/google.html")
