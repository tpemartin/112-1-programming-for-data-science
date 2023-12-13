# https://github.com/tpemartin/112-1-programming-for-data-science/issues/13#issuecomment-1842200202

library(readr)

# 111年1-12月娛樂稅稅源月報表UTF-8 ----
Tax<- read_csv("https://raw.githubusercontent.com/Urifoz/112-1-final-project/main/111年1-12月娛樂稅稅源月報表UTF-8.csv")
View(Tax)

## Original
Tax$...1
result <- grep("月合計", Tax$...1)
print(result)
print(Tax$營業總額[result])

## Suggestion
Tax |>
  dplyr::filter(
    grepl("月合計", `...1`)
  ) -> Tax_monthlyTotal

View(Tax_monthlyTotal)
