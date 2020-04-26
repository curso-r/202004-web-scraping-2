library(httr)
library(xml2)
library(magrittr)

url <- "https://dejt.jt.jus.br/dejt/f/n/diariocon"

viewstate <- url %>%
  GET(config(ssl_verifypeer = FALSE)) %>%
  content() %>%
  xml_find_first('//input[@name="javax.faces.ViewState"]') %>%
  xml_attr("value")

body <- list(
  "corpo:formulario:dataIni" = "17/04/2020",
  "corpo:formulario:dataFim" = "17/04/2020",
  "corpo:formulario:tipoCaderno" = "",
  "corpo:formulario:tribunal" = "",
  "corpo:formulario:ordenacaoPlc" = "",
  "navDe" = "",
  "detCorrPlc" = "",
  "tabCorrPlc" = "",
  "detCorrPlcPaginado" = "",
  "exibeEdDocPlc" = "",
  "indExcDetPlc" = "",
  "org.apache.myfaces.trinidad.faces.FORM" = "corpo:formulario",
  "_noJavaScript" = "false",
  "javax.faces.ViewState" = viewstate,
  "source" = "corpo:formulario:botaoAcaoPesquisar"
)

resp <- POST(
  url, body = body, encode = "form",
  config(ssl_verifypeer = FALSE),
  write_disk("arqs/dejt.html", overwrite = TRUE)
)

jid <- resp %>%
  read_html() %>%
  xml_find_all("//button") %>%
  xml_attr("onclick") %>%
  stringr::str_extract("(?<=plcLogicaItens:0:)j_id[0-9]+") %>%
  magrittr::extract(!is.na(.))

# Descubra o corpo da requisição para baixar um dos PDFs do DEJT.

body2 <- list(
  "corpo:formulario:dataIni" = "17/04/2020",
  "corpo:formulario:dataFim" = "17/04/2020",
  "corpo:formulario:tipoCaderno" = "",
  "corpo:formulario:tribunal" = "",
  "corpo:formulario:ordenacaoPlc" = "",
  "navDe" = "",
  "detCorrPlc" = "",
  "tabCorrPlc" = "",
  "detCorrPlcPaginado" = "",
  "exibeEdDocPlc" = "",
  "indExcDetPlc" = "",
  "org.apache.myfaces.trinidad.faces.FORM" = "corpo:formulario",
  "_noJavaScript" = "false",
  "javax.faces.ViewState" = viewstate,
  "source" = paste0("corpo:formulario:plcLogicaItens:", 0, ":", jid)
)

POST(
  url, body = body2,
  write_disk("arqs/dejt.pdf"),
  config(ssl_verifypeer = FALSE)
)
