library(readr)
md <- jsonlite::fromJSON("https://vipmbr.cpc.com.tw/openData/electricmotoData")

name <- md$站名
number <- md$郵遞區號
address <- md$地址
service <- md$服務類型
code <- md$站代號
charger <- data.frame(
  name = md$站名,
  number = md$郵遞區號,
  address = md$地址
)
if (FALSE) {
  table(charger)
  View(charger)
  list1 <- list(
    name = md$站名,
    number = md$郵遞區號,
    address = md$地址
  )
  list1[[1]][[1]]

  class(charger)
  table(number)
}

# 分析充電站類型、各有幾個----
if (FALSE) {
  data.frame(
    service
  )
  table(service)
}

md$服務類型 |>
  table()

# 分析服務時段（是否為24小時服務）----
## old ----
{
  pick <- md$站名 == "金山站"
  md$提供服務時段[pick]
  class(md$提供服務時段)
  table(md$提供服務時段)

  md$提供服務時段 |> head()
}
## new ----
md |>
  dplyr::filter(
    提供服務時段 == "00:00-24:00"
  ) -> md24hrs

View(md24hrs)


# 分析地區（北、中、南）
sort(number, decreasing = T)
