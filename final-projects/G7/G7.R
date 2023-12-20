library(readr)
dq_download_csv <- read_csv("https://quality.data.gov.tw//dq_download_csv.php?nid=160174&md5_url=7de169d7b036bb2b0c7abb7546992ad8")
View(dq_download)

dplyr::glimpse(dq_download_csv)

dq_download_csv$年度
dq_download_csv$死亡原因
dq_download_csv$`人數-男`
dq_download_csv$`給付金額-男`
dq_download_csv$`人數-女`
dq_download_csv$`給付金額-女`
dq_download_csv$`人數-合計`
dq_download_csv$人數比率
dq_download_csv$`給付金額-合計`
dq_download_csv$給付金額比率

data <- (dq_download_csv)

# 把死亡人數性別為男者由高排到低
sort_data <- data[order(data$`人數-男`), ]

dq_download_csv$年度 |>
  table() |>
  sort(decreasing = TRUE)

#找出最主要的死亡原因
whichIsMax <- which.max(dq_download_csv$`人數-合計`)
majorreason = dq_download_csv$死亡原因[whichIsMax]

#最高死亡原因的男女比
dq_download_csv$`人數-男`[whichIsMax]/dq_download_csv$`人數-女`[whichIsMax]

#平均每位男性死亡後給付金額
dq_download_csv$`給付金額-男`[whichIsMax]/dq_download_csv$`人數-男`[whichIsMax]

#平均每位女性死亡後給付金額
dq_download_csv$`給付金額-女`[whichIsMax]/dq_download_csv$`人數-女`[whichIsMax]

# 算出來的結果是一個值的，如一個數字,一個名詞，的可以用dplyr::summarise

dq_download_csv |>
  dplyr::summarise(
    最高死亡原因 = 死亡原因[whichIsMax],
    最高死亡原因的男女比 = `人數-男`[whichIsMax]/`人數-女`[whichIsMax],
    平均每位男性死亡後給付金額 = `給付金額-男`[whichIsMax]/`人數-男`[whichIsMax],
    平均每位女性死亡後給付金額 = `給付金額-女`[whichIsMax]/`人數-女`[whichIsMax]
  ) |>
  dplyr::glimpse()
