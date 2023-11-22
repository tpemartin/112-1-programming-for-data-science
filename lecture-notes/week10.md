```R
# To ensure Chinese characters are displayed correctly
options(encoding = "UTF-8")
Sys.setlocale("LC_CTYPE", "zh_TW.UTF-8")
```


```R
flights <- readRDS("data/flights_week10.rds")
```


```R
flightsData <- flights$data[[1]]$data_frame
```


```R
dplyr::glimpse(flightsData)
```

Data frame `flightsData` has a string column `DepartureTime` with values like "2023-10-13 15:00". There is another column `DepartureTimeZone` with values like "Asia/Taipei" telling us the `DepartureTime` time zone for each value. How to convert `DepartureTime` to a `datetime` column with the correct time zone, using dplyr and lubridate packages in R? 


```R

library(dplyr)
library(lubridate)

flightsData <- flightsData %>%
  group_by(DepartureTimeZone) %>%
  mutate(DepartureTime = ymd_hms(DepartureTime, tz = DepartureTimeZone[[1]])) |>
  glimpse()

```

# Parse time with different time zone

Our data come from different time zone. We can use `lubridate::ymd_hm(..., tz={time zone})` to parse `...` into the same `{time zone}` value. 

## Split data according to time zone


```R
# 3. parse time with time zone
## split flightsData according to its timezone
flightsData |> split(flightsData$DepartureTimeZone) -> split_flightsData
```


```R
head(split_flightsData[[1]], 3)
head(split_flightsData[[2]]$DepartureTimeZone, 3)
head(split_flightsData[[3]]$DepartureTimeZone, 3)
```

## Parsing a time zone



```R
# for each sub data frame
.x=1 # say the first one
# we want to parse the time
split_flightsData[[.x]]$DepartureTime <- 
  lubridate::ymd_hm(split_flightsData[[.x]]$DepartureTime, tz = split_flightsData[[.x]]$DepartureTimeZone[[1]]) 

```

- `tz = groupXdata$DepartureTimeZone[[1]]` only take ONE time zone value because the same sub data frame has the same time zone. Also `tz=` can take in only one string.


### dplyr::mutate

If you have an expression like

```
data_frame$some_column <- operations on ... other data_frame$column(s)
```

you can use `dplyr::mutate` to do the same thing:

```
data_frame |>
  dplyr::mutate(
    some_column = operations on ... other column(s)
  )
```

In our previous example `data_frame` is `split_flightData[[.x]]`, so we can write


```R
split_flightsData[[.x]] |>
  dplyr::mutate(
    DepartureTime = 
      lubridate::ymd_hm(DepartureTime, tz = DepartureTimeZone[[1]])
  )
```

### dplyr::group_by

So far we have ...

- If you want going to work on every group in your split data frame, which is split based on `DepartureTimeZone`, then you can replace `split_flightsData[[.x]] ` with `flightsData |> dplyr::group_by(DepartureTimeZone) |> dplyr::mutate(...) |> dplyr::ungroup()`


- If we want to `flightsData |> split(flightsData$DepartureTimeZone) ` and then work on each group separately on other dplyr procedure. Then we can use `dplyr::group_by` as
`flightsData |> dplyr::group_by(DepartureTimeZone) |>  {continue to other dplyr procedure}`


```R
flightsData |>
    dplyr::group_by(DepartureTimeZone) |> # split and do the following on each sub data frame
    dplyr::mutate(
        DepartureTime = lubridate::ymd_hm(DepartureTime, tz = DepartureTimeZone[[1]]) # parse time
    ) |>
    dplyr::ungroup() -> # unsplit the data frame
    flightsData2
```

- end your procedure with `dplyr::ungroup()` to ungroup the data frame.


```R
dplyr::glimpse(flightsData2)
```

jupyter nbconvert --to markdown lecture-notes/week10.ipynb

