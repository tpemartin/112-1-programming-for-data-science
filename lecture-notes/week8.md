```R
# To ensure Chinese characters are displayed correctly
options(encoding = "UTF-8")
Sys.setlocale("LC_CTYPE", "zh_TW.UTF-8")
```


'zh_TW.UTF-8'


# Date/Time

- [textbook 4.2.3](https://tpemartin.github.io/NTPU-R-for-Data-Science-EN/operations-on-atomic-vectors.html#datetime)

Download flightsData_week8.rds


```R
flightsData <- readRDS("data/flightsData_week8.rds")
```


```R
dplyr::glimpse(flightsData)
```

    Rows: 4,941
    Columns: 24
    $ AirlineID          [3m[90m<fct>[39m[23m 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 5J,~
    $ ScheduleStartDate  [3m[90m<chr>[39m[23m "2023-10-13", "2023-10-20", "2023-10-27", "2023-10-~
    $ ScheduleEndDate    [3m[90m<chr>[39m[23m "2023-10-15", "2023-10-22", "2023-10-27", "2023-10-~
    $ FlightNumber       [3m[90m<chr>[39m[23m "3U3783", "3U3783", "3U3783", "3U3784", "3U3784", "~
    $ DepartureAirportID [3m[90m<chr>[39m[23m "CKG", "CKG", "CKG", "TSA", "TSA", "TSA", "TFU", "T~
    $ DepartureTime      [3m[90m<chr>[39m[23m "15:00", "15:00", "15:00", "19:00", "19:00", "19:00~
    $ CodeShare          [3m[90m<list>[39m[23m [<data.frame[0 x 0]>], [<data.frame[0 x 0]>], [<da~
    $ ArrivalAirportID   [3m[90m<chr>[39m[23m "TSA", "TSA", "TSA", "CKG", "CKG", "CKG", "TSA", "T~
    $ ArrivalTime        [3m[90m<chr>[39m[23m "18:00", "18:00", "18:00", "22:15", "22:15", "22:15~
    $ Monday             [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRU~
    $ Tuesday            [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA~
    $ Wednesday          [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRU~
    $ Thursday           [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA~
    $ Friday             [3m[90m<lgl>[39m[23m TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRU~
    $ Saturday           [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA~
    $ Sunday             [3m[90m<lgl>[39m[23m TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, F~
    $ UpdateTime         [3m[90m<chr>[39m[23m "2023-10-10T08:26:07+08:00", "2023-10-10T08:26:07+0~
    $ VersionID          [3m[90m<int>[39m[23m 1111, 1111, 1111, 1111, 1111, 1111, 1111, 1111, 111~
    $ Terminal           [3m[90m<chr>[39m[23m NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "1"~
    $ num_codeShare      [3m[90m<int>[39m[23m 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    $ DepartureTimeZone  [3m[90m<chr>[39m[23m "Asia/Shanghai", "Asia/Shanghai", "Asia/Shanghai", ~
    $ ArrivalTimeZone    [3m[90m<chr>[39m[23m "Asia/Taipei", "Asia/Taipei", "Asia/Taipei", "Asia/~
    $ DepartTaiwan       [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE~
    $ ArriveTaiwan       [3m[90m<lgl>[39m[23m TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, ~


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


<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>475</li><li>476</li><li>477</li><li>478</li><li>479</li><li>480</li><li>492</li><li>493</li><li>494</li><li>516</li><li>517</li><li>518</li><li>3346</li><li>3347</li><li>3348</li></ol>



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


<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>'2023-10-13 15:00'</li><li>'2023-10-20 15:00'</li><li>'2023-10-27 15:00'</li><li>'2023-10-13 19:00'</li><li>'2023-10-20 19:00'</li><li>'2023-10-27 19:00'</li></ol>




```R
flightsData$DepartureTime <- departureTime # replace the old DepartureTime inside the data frame
```




```R
names(flightsData)

```


<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>'AirlineID'</li><li>'ScheduleStartDate'</li><li>'ScheduleEndDate'</li><li>'FlightNumber'</li><li>'DepartureAirportID'</li><li>'DepartureTime'</li><li>'CodeShare'</li><li>'ArrivalAirportID'</li><li>'ArrivalTime'</li><li>'Monday'</li><li>'Tuesday'</li><li>'Wednesday'</li><li>'Thursday'</li><li>'Friday'</li><li>'Saturday'</li><li>'Sunday'</li><li>'UpdateTime'</li><li>'VersionID'</li><li>'Terminal'</li><li>'num_codeShare'</li><li>'DepartureTimeZone'</li><li>'ArrivalTimeZone'</li><li>'DepartTaiwan'</li><li>'ArriveTaiwan'</li></ol>





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


    [1] "2023-10-09 00:05:00 CST" "2024-01-18 14:30:00 CST"



    
    2023-10-23 2023-10-16 2023-10-09 2023-10-10 2023-10-17 2023-10-24 
           539        531        517        118        110        103 


# Exercise

Do the same procedure on `ArrivalTime`.
