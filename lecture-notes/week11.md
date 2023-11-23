```R
# To ensure Chinese characters are displayed correctly
options(encoding = "UTF-8")
Sys.setlocale("LC_CTYPE", "zh_TW.UTF-8")
```

# Recap

## week 8, 9 & 10

Previously. `ScheduleStartDate` is in `Date` class, `DepartureTime` is still in `character` class. Our goal is to have a `Date/Time` class `DepartureTime`. 

> However only a string like "2018-01-01 10:09" with its timezone supplied can be converted to a `Date/Time` class.


```R
# demo data 
flightsData <- data.frame(
  ScheduleStartDate = lubridate::ymd(c("2023-10-10", "2023-10-09")),
  DepartureTime = c("10:00+1","12:20"),
  DepartureTimeZone = c("Asia/Bangkok", "Asia/Taipei")
)
dplyr::glimpse(flightsData)
```


For `DepartureTime`, We need to

1. Find out which `ScheduleStartDate` needs to plus one day, and plus one day on those `ScheduleStartDate`.



```R
# week 8
whichNeedPlus1 <- grep(pattern = "+1", flightsData$DepartureTime, fixed = TRUE) # fixed=TRUE, not treating "+1" as REGEX

departureDate <- flightsData$ScheduleStartDate # create departureDate object
departureDate[whichNeedPlus1] <- departureDate[whichNeedPlus1] + lubridate::days(1) # element values replacement
```


```R
# before
flightsData$ScheduleStartDate
# after
departureDate 
```


2. Paste `ScheduleStartDate` and `DepartureTime` together -- remove `+1` from `DepartureTime` string if there is `+1`.


```R
flightsData$DepartureTime
```


```R
# week 9
departureTimeString <- flightsData$DepartureTime
# remove "+1" at the end
departureTimeString <- flightsData$DepartureTime
departureTimeString <- sub("+1", "", departureTimeString, fixed = T) # find "+1" pattern and replace it with ""

departureTime <- paste(departureDate, departureTimeString)
flightsData$DepartureTime <- departureTime 

```


```R
departureTimeString
departureTime
flightsData$DepartureTime
```

3. Parse the string into `Data/Time` class with time zone specification



```R
# week 10
flightsData |>
    dplyr::group_by(DepartureTimeZone) |>
    dplyr::mutate(
        DepartureTime = lubridate::ymd_hm(DepartureTime, tz = DepartureTimeZone[[1]])
    ) |>
    dplyr::ungroup() -> flightsData_new

flightsData_new
```


```R
flightsData$DepartureTime
flightsData_new$DepartureTime
```

- Within a Data/Time class vector, all values are stored in the same time zone. That is why they look different.

# Programming block

Codes surrounded by `{}` are programming block: 

  - used to group statements together.
  - If there is a binding with the programming block, i.e. `<- {}`, `= {}` or `{} ->` is used, the last executed statement in the block will be returned. Otherwise, the block will return `NULL`.



```R
# mini example
{
  # Perform some operations or calculations
  x <- 10
  y <- 20
  result <- x + y
  
} -> output

output
```


```R
output2 = {
  # Perform some operations or calculations
  x <- 10
  y <- 20
  result <- x + y
}

output2
```

- No matter which direction of binding you are using, the bindede value is always the last exectued statement in the block `result <- x + y`


```R
output3 <- {
    # Perform some operations or calculations
    x <- 10
    y <- 20
    if (x < 20) {
        result <- x + y
    } else {
        result <- 70
    }
}
output3

```

- last executed line is not always the last line in the block. 


```R
flightsData <- data.frame(
  ScheduleStartDate = lubridate::ymd(c("2023-10-10", "2023-10-09")),
  DepartureTime = c("10:00+1", "12:20"),
  DepartureTimeZone = c("Asia/Bangkok", "Asia/Taipei")
)

flightsData

{
  # week 8
  whichNeedPlus1 <- grep(pattern = "+1", flightsData$DepartureTime, fixed = TRUE) # fixed=TRUE, not treating "+1" as REGEX

  departureDate <- flightsData$ScheduleStartDate # create departureDate object
  departureDate[whichNeedPlus1] <- departureDate[whichNeedPlus1] + lubridate::days(1) # element values replacement

  # week 9
  departureTimeString <- flightsData$DepartureTime
  # remove "+1" at the end
  departureTimeString <- flightsData$DepartureTime
  departureTimeString <- sub("+1", "", departureTimeString, fixed = T) # find "+1" pattern and replace it with ""

  departureTime <- paste(departureDate, departureTimeString)
  flightsData$DepartureTime <- departureTime

  # week 10
  flightsData |>
    dplyr::group_by(DepartureTimeZone) |>
    dplyr::mutate(
      DepartureTime = lubridate::ymd_hm(DepartureTime, tz = DepartureTimeZone[[1]])
    ) |>
    dplyr::ungroup() -> flightsData_new

  flightsData_new
}

```

# Function

Sometimes you want to reuse a block of code with a slightly different setup. You can do this by writing a function that wraps around the programming block. 

## 1. resuse on other objects

`function_name <- function(object_name_to_be_substituted_inside_the_programming_block) { programming block }`


```R
# sum odd index values
fullValues <- c(45.4, 44.8, 37.3, 37.9, 28, 11.8, 39.7, 18.4, 41.2, 29.8, 1, 
44.2)
{
  odd_indices <- seq(1, length(fullValues), 2)
  sum_odd <- sum(fullValues[odd_indices])
  sum_odd
} 

```


```R
myfun <- function(fullValues){
  odd_indices <- seq(1, length(fullValues), 2)
  sum_odd <- sum(fullValues[odd_indices])
  sum_odd
} 
```


```R
fullValues2 <- c(13.6, 31.9, 3.4, 7, 21.7, 45.4, 19.3, 24.7, 10.3, 14.8, 29.2, 12.1)
```


```R
myfun(fullValues2)
```

## 2. have flexible values

Suppose I want to reuse the sum on different sequences of numbers, with different increment of the sequence. Currently it is set to 2 (`seq(1, length(fullValues), 2)`)

This involves two steps (1) replace the value with a object name, (2) put the object name as input argument of the function.


```R
myfun2 <- function(fullValues, increment){ # increment is an input argument
  odd_indices <- seq(1, length(fullValues), increment) # repace 2 with increment object name
  sum_odd <- sum(fullValues[odd_indices])
  sum_odd
} 
```


```R
myfun2(fullValues2, 2)
myfun2(fullValues2, 3)
```

## Function return

When you bind the function call to an object, the returned value from the the function block will be assigned to the object.


```R
result <- myfun2(fullValues2, 2)
result
```


If you simply wrap around your programming block into a function, the returned value depends on your last statement from the programming block:

- if it is a name call or using `print`, the value of the object will be returned.
- if it is a return statement, the value of the return statement will be returned.
- otherwise, `NULL` will be returned.


```R
myfun2 <- function(fullValues, increment){ # increment is an input argument
  odd_indices <- seq(1, length(fullValues), increment) # repace 2 with increment object name
  sum_odd <- sum(fullValues[odd_indices])
  cat(sum_odd) # print on screen without return value
}
```


```R
result <- myfun2(fullValues2, 2)
result
```

## Application on flightsData

Suppose we have another data need to be date/time parsed on its `DepartureTime` column.



```R
flightsData2 <- data.frame(
  ScheduleStartDate = lubridate::ymd(c("2023-11-10", "2023-11-19")),
  DepartureTime = c("10:00+1","12:20+1"),
  DepartureTimeZone = c("Asia/Bangkok", "Asia/Taipei")
)
```


```R
parse_departureTime <- function(flightsData){
  # week 8
  whichNeedPlus1 <- grep(pattern = "+1", flightsData$DepartureTime, fixed = TRUE) # fixed=TRUE, not treating "+1" as REGEX

  departureDate <- flightsData$ScheduleStartDate # create departureDate object
  departureDate[whichNeedPlus1] <- departureDate[whichNeedPlus1] + lubridate::days(1) # element values replacement

  # week 9
  departureTimeString <- flightsData$DepartureTime
  # remove "+1" at the end
  departureTimeString <- flightsData$DepartureTime
  departureTimeString <- sub("+1", "", departureTimeString, fixed = T) # find "+1" pattern and replace it with ""

  departureTime <- paste(departureDate, departureTimeString)
  flightsData$DepartureTime <- departureTime

  # week 10
  flightsData |>
    dplyr::group_by(DepartureTimeZone) |>
    dplyr::mutate(
      DepartureTime = lubridate::ymd_hm(DepartureTime, tz = DepartureTimeZone[[1]])
    ) |>
    dplyr::ungroup() -> flightsData_new

  flightsData_new
}

```


```R
flightsData2
parse_departureTime(flightsData2)
```


```R
flights <- readRDS("../data/flights_week11.rds")
flightsData <- flights$data[[1]]$data_frame
```


```R
dplyr::glimpse(flightsData)
```


```R
library(dplyr)

# select relevant columns
flightsData |>
  select(ScheduleStartDate, ArrivalTime, ArrivalTimeZone) -> flightsData_selected

# rename for parse_departureTime function to work
names(flightsData_selected)[c(2,3)] <- c("DepartureTime", "DepartureTimeZone")

```


```R
flightsData_renamed_parsed <- parse_departureTime(flightsData_renamed)
dplyr::glimpse(flightsData_renamed_parsed)
```


```R
flightsData[,c("ArriavlTime", "ArrivalTimeZone")] <- 
    flightsData_renamed_parsed[,c("DepartureTime", "DepartureTimeZone")]
```


```R
glimpse(flightsData)
```
