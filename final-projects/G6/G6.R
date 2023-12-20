library(readr)
dg6 <- readr::read_csv("https://data.cip.gov.tw/API/v1/dump/datastore/A53000000A-112010-003")
View(dg6)

# 男女看報紙比例----
## old ----
if(FALSE)
{
dg6 |>
  dplyr::filter(
    類別 == "性別"
  ) -> dg6_1

dg6_1 |>
  split(
    dg6_1$項目別
  ) -> split_dg6_1

split_dg6_1$女$看報紙/
  split_dg6_1$男$看報紙 -> summarise1

}
## new ----
## 若沒有tidyr則安裝
if(!require(tidyr)) install.packages("tidyr")

dg6 |>
  dplyr::select(
    年度, 類別,看報紙,項目別
  ) |>
  dplyr::filter(
    類別 == "性別"
  ) -> dg6_filtered

head(dg6_filtered)

dg6_filtered |>
    tidyr::pivot_wider(
    names_from = "項目別",
    values_from = "看報紙"
  )  |>
  dplyr::mutate(
      男_女比=男/女
  )

# others ----
names(summarise1) <-
  split_dg6_1$女$年度

summarise1


dg6 |>
  dplyr::filter(
    類別 == "年齡"
  ) -> dg6_2

View(dg6_2)

dg6_2 |>
  split(
    dg6_2$項目別
  ) -> split_dg6_2

split_dg6_2$"15 ~ 19歲"$看報紙/
  split_dg6_2$"65歲及以上"$看報紙 -> summarise2

names(summarise2) <-
  split_dg6_2$"15 ~ 19歲"$年度

summarise2
