library(readr)
library(dplyr)
data1 <- read_csv("https://raw.githubusercontent.com/angelaachen/112-1-final-project-G1/main/110年度兒童及少年未來教育與展帳戶-開戶率.csv",
                  locale = locale(encoding = "BIG5"))
data <- jsonlite::fromJSON("data.json")
class(data)
on_stop_id <- data$on_stop_id
class(on_stop_id)
table(on_stop_id)
data$on_stop_id[[527]]

test <- arrange(data,on_stop_id)
