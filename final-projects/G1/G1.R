#前置作業----
library(readr)
library(dplyr)
data <- jsonlite::fromJSON("data.json")

#命名Values----
on_stop <- data$on_stop
off_stop <- data$off_stop
sum_of_txn_times <- data$sum_of_txn_times

data_arranged <-
  data |>
  dplyr::arrange(on_stop) |>
  dplyr::relocate(on_stop)
View(data_arranged)

data_arranged |>
  purrr::map(class)

#改變data$sum_of_txn_times屬性----
data$sum_of_txn_times <- as.numeric(data$sum_of_txn_times)

data |>
  dplyr::mutate(
    sum_of_txn_times = as.numeric(sum_of_txn_times)
  ) -> data

summaries <- list()
#sum up交易次數by on/off stop----
sum_of_txn_times_numbered_on_stop <-
  data |> dplyr::group_by(on_stop) |>
  dplyr::summarise(
    sum_of_txn_times = sum(sum_of_txn_times)
  )
summaries$`sum up交易次數by on_stop` <- sum_of_txn_times_numbered_on_stop

sum_of_txn_times_numbered_off_stop <-
  data |> dplyr::group_by(off_stop) |>
  dplyr::summarise(
    sum_of_txn_times = sum(sum_of_txn_times)
  )
summaries$`sum up交易次數by off_stop` <- sum_of_txn_times_numbered_off_stop

saveRDS(summaries, file="summaries.Rds")
#gg----


