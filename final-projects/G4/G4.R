library(readr)

# Banking ----
banking <- read_csv("https://raw.githubusercontent.com/LIAOMINSHIU/112-1-final-project-1/main/banking14.csv")
View(banking)

# 癌症資料 ----
CANCER <- read_csv("https://raw.githubusercontent.com/LIAOMINSHIU/112-1-final-project-1/main/File_22018.csv")
View(CANCER)

dplyr::glimpse(CANCER)
str(CANCER)
sort(CANCER$癌症診斷年)
table(CANCER$癌症診斷年)
## 資料年份 ----
CANCER$癌症診斷年 |> range()


