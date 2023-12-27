library(readr)
dq_download_csv <- read_csv("https://quality.data.gov.tw//dq_download_csv.php?nid=160174&md5_url=7de169d7b036bb2b0c7abb7546992ad8")
View(dq_download)

dplyr::glimpse(dq_download_csv)

data <- (dq_download_csv)

# 把死亡人數性別為男者由低排到高
sort_data <- data[order(data$`人數-男`), ]

dq_download_csv$年度 |>
  table() |>
  sort(decreasing = TRUE)

#找出最主要的死亡原因
whichIsMax <- which.max(dq_download_csv$`人數-合計`)
#找出最次要的死亡原因
whichIsMin <- which.min(dq_download_csv$`人數-合計`)
#找出男性最主要的死亡原因
whichIsMax2 <- which.max(dq_download_csv$`人數-男`)
#找出女性最主要的死亡原因
whichIsMax3 <- which.max(dq_download_csv$`人數-女`)

#最高死亡原因的男女比
#平均每位男性死亡後給付金額
#平均每位女性死亡後給付金額
#平均死亡後給付金額的男女比
#算出來的結果是一個值的，如一個數字,一個名詞，的可以用dplyr::summarise
dq_download_csv |>
  dplyr::summarise(
    最高死亡原因  = 死亡原因[whichIsMax],
    最低死亡原因  = 死亡原因[whichIsMin],
    男性最高最主要的死亡原因 = 死亡原因[whichIsMax2],
    女性最高最主要的死亡原因 = 死亡原因[whichIsMax3],
    最高死亡原因的男女比 = `人數-男`[whichIsMax]/`人數-女`[whichIsMax],
    平均每位男性死亡後給付金額 = `給付金額-男`[whichIsMax]/`人數-男`[whichIsMax],
    平均每位女性死亡後給付金額 = `給付金額-女`[whichIsMax]/`人數-女`[whichIsMax],
    平均死亡後給付金額的男女比 = {`給付金額-男`[whichIsMax]/`人數-男`[whichIsMax]}/{`給付金額-女`[whichIsMax]/`人數-女`[whichIsMax]}
  ) |>
  dplyr::glimpse()

