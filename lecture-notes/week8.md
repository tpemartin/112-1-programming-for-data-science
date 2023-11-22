```R
# To ensure Chinese characters are displayed correctly
options(encoding = "UTF-8")
Sys.setlocale("LC_CTYPE", "zh_TW.UTF-8")
```

# Date/Time

- [textbook 4.2.3](https://tpemartin.github.io/NTPU-R-for-Data-Science-EN/operations-on-atomic-vectors.html#datetime)

Download flightsData_week8.rds


```R
flightsData <- readRDS("data/flightsData_week8.rds")
```


```R
dplyr::glimpse(flightsData)
```

- DepartureTime/ArrivalTime: Some of them has date change "+1" at the end.   
- To parse **Time**, we need date/time/timzone. 
  - date, time: paste date and time together to fit into `lubridate::ymd_hm` format. 
  - Be careful some date need to plus 1 day to fit into the Departure/Arrival Airport's local time expression

Take `DepartureTime` as an example. We need to

1. Find out which `ScheduleStartDate` needs to plus one day, and plus one day on those `ScheduleStartDate`.
2. Paste `ScheduleStartDate` and `DepartureTime` together. 
3. Parse the string into `Data/Time` class with time zone specification


```R
# 1. which ScheduleStartDate need plus 1
## Find out which DepartureTime has +1 at the end
whichNeedPlus1 <- grep(pattern = "+1", flightsData$DepartureTime, fixed = TRUE)

whichNeedPlus1
```

- `fixed=TRUE` means the pattern is fixed as the string specified, i.e. "+1" is a fixed pattern no other possible interpretation. This option must always be there until you learn Regular Expression (which will no be taught at this level course).


```R
## Add one day to those ScheduleStartDate

### teach R understand date so it can do plus one day later
flightsData$ScheduleStartDate <- lubridate::ymd(flightsData$ScheduleStartDate)
```


```R
departureDate <- flightsData$ScheduleStartDate
departureDate[whichNeedPlus1] <- departureDate[whichNeedPlus1] + lubridate::days(1)
```


```R
# 2. paste date time together
departureTimeString <- flightsData$DepartureTime
# remove "+1" at the end
departureTimeString <- flightsData$DepartureTime
departureTimeString <- sub("+1", "", departureTimeString, fixed = T)

departureTime <- paste(departureDate, departureTimeString)

head(departureTime)

```


```R
flightsData$DepartureTime <- departureTime # replace the old DepartureTime inside the data frame
```




```R
names(flightsData)

```

# Data summary

## Departure Date/Time


```R
flightsData2$ArriveTaiwan
```


```R
### Range

flightsData2$DepartureTime |> range() |> lubridate::with_tz("Asia/Taipei")

### ScheduleStartDate 
flightsData2 |> split(flightsData2$ArriveTaiwan) -> split_flightsData2

#### Departure from Taiwan
flightsData2 |>
  dplyr::filter(
    DepartTaiwan 
  ) -> DepartFlights

DepartFlights$ScheduleStartDate |> table() |> sort(d=T) |> head()



```

# Exercise

Do the same procedure on `ArrivalTime`.
