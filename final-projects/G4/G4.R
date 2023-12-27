library(readr)
CANCER <- read_csv("https://raw.githubusercontent.com/LIAOMINSHIU/112-1-final-project-1/main/File_22018.csv")
dplyr::glimpse(CANCER)

CANCER |>
  # dplyr::filter(
  #   縣市別=="全國"
  # ) |>
  dplyr::select(
    癌症診斷年, 癌症別, 縣市別, 性別, 癌症發生數
  ) |>
  tidyr::pivot_wider(
    names_from = "性別",
    values_from = "癌症發生數"
  ) |>
  dplyr::mutate(
    男女比=男/女
  ) |>
  dplyr::select(
    癌症診斷年, 癌症別, 縣市別,男女比
  ) |>
  tidyr::pivot_wider(
    names_from = "縣市別",
    values_from = "男女比"
  ) |>
  View()
#rename----
##library(dplyr)
##CANCER |>
# rename(
#   年齡標準化發生率 = `年齡標準化發生率  WHO 2000世界標準人口 (每10萬人口)`
# )
#paring----
##癌症別 46種----
class(CANCER$癌症別)
factor (CANCER$癌症別)
CANCER$癌症別<-factor(CANCER$癌症別)
class(CANCER$癌症別)
fct_CancerType<-factor(CANCER$癌症別)
levels(fct_CancerType)
unique_CancerType <- unique(CANCER$癌症別)
unique_CancerType

##癌症診斷年_1979----
class(CANCER$癌症診斷年)
factor (CANCER$癌症診斷年)
CANCER$癌症診斷年<-factor(CANCER$癌症診斷年)
class(CANCER$癌症診斷年)
fct_CancerTime<-factor(CANCER$癌症診斷年)
levels(fct_CancerTime)

##區域（縣市別）----
class(CANCER$縣市別)
factor (CANCER$縣市別)
CANCER$縣市別<-factor(CANCER$縣市別)
class(CANCER$縣市別)
fct_CancerCity<-factor(CANCER$縣市別)
levels(fct_CancerCity)
unique_CancerType <- unique(CANCER$縣市別)
unique_CancerType

##性別----
class(CANCER$性別)
factor (CANCER$性別)
CANCER$性別<-factor(CANCER$性別)
class(CANCER$性別)
fct_CancerGender<-factor(CANCER$性別)
levels(fct_CancerGender)

#以下分析只看全國欄位的資料
country_data <- subset(CANCER, 縣市別 == "全國")
View(country_data)

#分析癌症發生數----

##自1979-2020年以來哪一個癌症發生次數最高----
country_data|>
  dplyr::group_by(
    癌症別
  )|>
  dplyr::summarise(
    癌症平均發生數 = mean(癌症發生數)
  )|>View()
###前三名是：「女性乳房」、「結直腸」以及「肺、支氣管及氣管」

##歷年各種癌症別癌症發生數變化----
data<-country_data %>%
  dplyr::filter(
    癌症別 %in% c("女性乳房", "結直腸", "肺、支氣管及氣管")
  ) %>%
  dplyr::group_by(癌症診斷年, 癌症別) %>%
  dplyr::summarise(癌症平均發生數 = mean(癌症發生數))

##將資料視覺化
library(ggplot2)
ggplot(data, aes(x = 癌症診斷年, y = 癌症平均發生數, fill = 癌症別)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "1978-2020年各癌症平均發生數", x = "年份", y = "平均發生數") +
  theme_minimal() +
  theme(legend.position = "top") +
  facet_wrap(~癌症別, scales = "free_y", ncol = 2)  # 根據癌症類型分面

##dplyr::arrange(
##癌症平均發生數
## )-> summaries$平均發生數
##View(summaries$平均年齡)

#各種癌症別發生的平均年齡、中位數與標準差----
##平均年齡----
country_data|>
  dplyr::group_by(
    癌症別
  )|>
  dplyr::summarise(
    癌症平均年齡 = mean(平均年齡)
  )->cancer_type_average_age
View(cancer_type_average_age)

##平均年齡中位數----
country_data |>
  dplyr::group_by(
    癌症別
  )|>
  dplyr::summarise(
    癌症平均年齡 = weighted.mean(平均年齡, 癌症發生數),
  ) ->cancer_type_midian_age
View(cancer_type_midian_age)

##平均年齡標準----
country_data |>
  dplyr::group_by(
    癌症別,
  )|>
  dplyr::summarise(
    癌症平均年齡標準化發生率= mean(`年齡標準化發生率  WHO 2000世界標準人口 (每10萬人口)`)
  )->cancer_type_standard_age
View(cancer_type_standard_age)

##平均年齡、中位數與標準差綜合分析----
# 假設三個資料框分別為 cancer_type_average_age、cancer_type_midian_age、cancer_type_standard_age

# 合併資料框 cancer_type_average_age 和 cancer_type_midian_age
merged_data <- merge(cancer_type_average_age, cancer_type_midian_age, by = "癌症別")

# 再合併資料框 merged_data 和 cancer_type_standard_age
final_merged_data <- merge(merged_data, cancer_type_standard_age, by = "癌症別")|>View()


## 假設你有一個名為cancer_data的資料框（data frame），包含所需的數據
## 列名可能類似 "CancerType", "AgeStandardizedRate", "MedianAge", "MeanAge"

## 安裝並載入必要的套件
install.packages("tidyverse")
library(tidyverse)

##資料處理和分析
CANCER %>%
  group_by(CancerType) %>%
  summarise(
    AvgAge = mean(MeanAge, na.rm = TRUE),
    MedianAge = median(MedianAge, na.rm = TRUE),
    AgeStandardizedRate = mean(AgeStandardizedRate, na.rm = TRUE)
  ) %>%
  print()


# Something wrong -----

# CANCER %>%
#   group_by(癌症別) %>%
#   summarise(
#     平均年齡 = mean(平均年齡, na.rm = TRUE),
#     年齡中位數 = median(年齡中位數, na.rm = TRUE),
#     年齡標準化發生率  WHO 2000世界標準人口 (每10萬人口) = mean(`年齡標準化發生率  WHO 2000世界標準人口 (每10萬人口)`, na.rm = TRUE)
#   ) %>%
#   print()


#性別與各種癌症別癌症發生數變化----


