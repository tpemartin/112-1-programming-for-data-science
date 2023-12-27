#前置作業----
library(readr)
library(dplyr)
data <- jsonlite::fromJSON("data.json")

#命名Values----
on_stop <- data$on_stop
off_stop <- data$off_stop
sum_of_txn_times <- data$sum_of_txn_times
data_arranged<- dplyr::arrange(data,"on_stop")

#改變data$sum_of_txn_times屬性----
data$sum_of_txn_times <- as.numeric(data$sum_of_txn_times)

#sum up交易次數by on/off stop----
sum_of_txn_times_numbered_on_stop <-
  data |> dplyr::group_by(on_stop) |>
  dplyr::summarise(
    sum_of_txn_times = sum(sum_of_txn_times)
  )  |> arrange(desc(sum_of_txn_times))

sum_of_txn_times_numbered_off_stop <-
  data |> dplyr::group_by(off_stop) |>
  dplyr::summarise(
    sum_of_txn_times = sum(sum_of_txn_times)
  )  |> arrange(desc(sum_of_txn_times))

#sum up交易次數by district_origin/district_destination----
sum_of_txn_times_numbered_district_origin <-
  data |> dplyr::group_by(district_origin) |>
  dplyr::summarise(
    sum_of_txn_times = sum(sum_of_txn_times)
  )  |> arrange(desc(sum_of_txn_times))

sum_of_txn_times_numbered_district_destination <-
  data |> dplyr::group_by(district_destination) |>
  dplyr::summarise(
    sum_of_txn_times = sum(sum_of_txn_times)
  )  |> arrange(desc(sum_of_txn_times))

#改變sum_of_txn_times_numbered_district_destination/origin屬性----
## old----
if(FALSE)
{
  as.numeric(sum_of_txn_times_numbered_district_destination$sum_of_txn_times)
  as.numeric(sum_of_txn_times_numbered_district_origin$sum_of_txn_times)

}
## new ----
{
  sum_of_txn_times_numbered_district_destination$sum_of_txn_times <- as.numeric(sum_of_txn_times_numbered_district_destination$sum_of_txn_times)
  sum_of_txn_times_numbered_district_origin$sum_of_txn_times <- as.numeric(sum_of_txn_times_numbered_district_origin$sum_of_txn_times)
}
### 這裡其實不用改class，因為前面數值運算完結果自然會是numeric class

#加總、占比----
SDS <- sum(sum_of_txn_times_numbered_district_destination$sum_of_txn_times)
SOS <- sum(sum_of_txn_times_numbered_district_origin$sum_of_txn_times)
