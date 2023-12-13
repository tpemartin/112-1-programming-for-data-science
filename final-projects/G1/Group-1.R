library(readr)
library(dplyr)

# 兒童少年開戶資料兒童及少年未來教育與展帳戶-開戶率 ----
data1 <- read_csv("https://raw.githubusercontent.com/angelaachen/112-1-final-project-G1/main/110年度兒童及少年未來教育與展帳戶-開戶率.csv",
                  locale = locale(encoding = "BIG5"))

#
data <- jsonlite::fromJSON("https://raw.githubusercontent.com/tpemartin/112-1-programming-for-data-science/main/final-projects/G1/data.json")

class(data)
on_stop_id <- data$on_stop_id
class(on_stop_id)
table(on_stop_id)
data$on_stop_id[[527]]

test <- dplyr::arrange(data,on_stop_id)
