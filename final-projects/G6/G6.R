library(readr)
dg6 <- readr::read_csv("https://data.cip.gov.tw/API/v1/dump/datastore/A53000000A-112010-003")
View(dg6)

dg6 |>
  split(dg6$類別) -> split_dg6
#老人跟年輕人看報紙找工作比例----
which(split_dg6$年齡$項目別 == "15 ~ 19歲")

split_dg6$年齡 |>
  dplyr::group_by(
    年度
  ) |>
  dplyr::summarise(
    老人跟年輕人看報紙找工作比例 =
      看報紙[[which(項目別 == "65歲及以上")]]/看報紙[[which(項目別 == "15 ~ 19歲")]]
  ) |> View()

