```R
# To ensure Chinese characters are displayed correctly
options(encoding = "UTF-8")
Sys.setlocale("LC_CTYPE", "zh_TW.UTF-8")
```


'zh_TW.UTF-8'



```R
flights <- readRDS("data/flights_week10.rds")
```


```R
flightsData <- flights$data[[1]]$data_frame
```


```R
dplyr::glimpse(flightsData)
```

    Rows: 4,941
    Columns: 24
    $ AirlineID          [3m[90m<fct>[39m[23m 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 5J,…
    $ ScheduleStartDate  [3m[90m<date>[39m[23m 2023-10-13, 2023-10-20, 2023-10-27, 2023-10-13, 20…
    $ ScheduleEndDate    [3m[90m<chr>[39m[23m "2023-10-15", "2023-10-22", "2023-10-27", "2023-10-…
    $ FlightNumber       [3m[90m<chr>[39m[23m "3U3783", "3U3783", "3U3783", "3U3784", "3U3784", "…
    $ DepartureAirportID [3m[90m<chr>[39m[23m "CKG", "CKG", "CKG", "TSA", "TSA", "TSA", "TFU", "T…
    $ DepartureTime      [3m[90m<chr>[39m[23m "2023-10-13 15:00", "2023-10-20 15:00", "2023-10-27…
    $ CodeShare          [3m[90m<list>[39m[23m [<data.frame[0 x 0]>], [<data.frame[0 x 0]>], [<da…
    $ ArrivalAirportID   [3m[90m<chr>[39m[23m "TSA", "TSA", "TSA", "CKG", "CKG", "CKG", "TSA", "T…
    $ ArrivalTime        [3m[90m<chr>[39m[23m "18:00", "18:00", "18:00", "22:15", "22:15", "22:15…
    $ Monday             [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRU…
    $ Tuesday            [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA…
    $ Wednesday          [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRU…
    $ Thursday           [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA…
    $ Friday             [3m[90m<lgl>[39m[23m TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRU…
    $ Saturday           [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA…
    $ Sunday             [3m[90m<lgl>[39m[23m TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, F…
    $ UpdateTime         [3m[90m<chr>[39m[23m "2023-10-10T08:26:07+08:00", "2023-10-10T08:26:07+0…
    $ VersionID          [3m[90m<int>[39m[23m 1111, 1111, 1111, 1111, 1111, 1111, 1111, 1111, 111…
    $ Terminal           [3m[90m<chr>[39m[23m NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "1"…
    $ num_codeShare      [3m[90m<int>[39m[23m 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    $ DepartureTimeZone  [3m[90m<chr>[39m[23m "Asia/Shanghai", "Asia/Shanghai", "Asia/Shanghai", …
    $ ArrivalTimeZone    [3m[90m<chr>[39m[23m "Asia/Taipei", "Asia/Taipei", "Asia/Taipei", "Asia/…
    $ DepartTaiwan       [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE…
    $ ArriveTaiwan       [3m[90m<lgl>[39m[23m TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, …



```R

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

    Rows: 4,941
    Columns: 24
    Groups: DepartureTimeZone [35]
    $ AirlineID          [3m[90m<fct>[39m[23m 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 3U, 5J,…
    $ ScheduleStartDate  [3m[90m<date>[39m[23m 2023-10-13, 2023-10-20, 2023-10-27, 2023-10-13, 20…
    $ ScheduleEndDate    [3m[90m<chr>[39m[23m "2023-10-15", "2023-10-22", "2023-10-27", "2023-10-…
    $ FlightNumber       [3m[90m<chr>[39m[23m "3U3783", "3U3783", "3U3783", "3U3784", "3U3784", "…
    $ DepartureAirportID [3m[90m<chr>[39m[23m "CKG", "CKG", "CKG", "TSA", "TSA", "TSA", "TFU", "T…
    $ DepartureTime      [3m[90m<dttm>[39m[23m NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    $ CodeShare          [3m[90m<list>[39m[23m [<data.frame[0 x 0]>], [<data.frame[0 x 0]>], [<da…
    $ ArrivalAirportID   [3m[90m<chr>[39m[23m "TSA", "TSA", "TSA", "CKG", "CKG", "CKG", "TSA", "T…
    $ ArrivalTime        [3m[90m<chr>[39m[23m "18:00", "18:00", "18:00", "22:15", "22:15", "22:15…
    $ Monday             [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRU…
    $ Tuesday            [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA…
    $ Wednesday          [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRU…
    $ Thursday           [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA…
    $ Friday             [3m[90m<lgl>[39m[23m TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRU…
    $ Saturday           [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FA…
    $ Sunday             [3m[90m<lgl>[39m[23m TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, F…
    $ UpdateTime         [3m[90m<chr>[39m[23m "2023-10-10T08:26:07+08:00", "2023-10-10T08:26:07+0…
    $ VersionID          [3m[90m<int>[39m[23m 1111, 1111, 1111, 1111, 1111, 1111, 1111, 1111, 111…
    $ Terminal           [3m[90m<chr>[39m[23m NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "1"…
    $ num_codeShare      [3m[90m<int>[39m[23m 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    $ DepartureTimeZone  [3m[90m<chr>[39m[23m "Asia/Shanghai", "Asia/Shanghai", "Asia/Shanghai", …
    $ ArrivalTimeZone    [3m[90m<chr>[39m[23m "Asia/Taipei", "Asia/Taipei", "Asia/Taipei", "Asia/…
    $ DepartTaiwan       [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE…
    $ ArriveTaiwan       [3m[90m<lgl>[39m[23m TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, …


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


<table class="dataframe">
<caption>A grouped_df: 3 × 24</caption>
<thead>
	<tr><th scope=col>AirlineID</th><th scope=col>ScheduleStartDate</th><th scope=col>ScheduleEndDate</th><th scope=col>FlightNumber</th><th scope=col>DepartureAirportID</th><th scope=col>DepartureTime</th><th scope=col>CodeShare</th><th scope=col>ArrivalAirportID</th><th scope=col>ArrivalTime</th><th scope=col>Monday</th><th scope=col>⋯</th><th scope=col>Saturday</th><th scope=col>Sunday</th><th scope=col>UpdateTime</th><th scope=col>VersionID</th><th scope=col>Terminal</th><th scope=col>num_codeShare</th><th scope=col>DepartureTimeZone</th><th scope=col>ArrivalTimeZone</th><th scope=col>DepartTaiwan</th><th scope=col>ArriveTaiwan</th></tr>
	<tr><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;date&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;list&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>⋯</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th></tr>
</thead>
<tbody>
	<tr><td>BR</td><td>2023-10-09</td><td>2023-10-15</td><td>BR051</td><td>IAH</td><td>NA</td><td>NULL</td><td>TPE</td><td>06:00+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>BR</td><td>2023-10-16</td><td>2023-10-22</td><td>BR051</td><td>IAH</td><td>NA</td><td>NULL</td><td>TPE</td><td>06:00+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>BR</td><td>2023-10-23</td><td>2023-10-28</td><td>BR051</td><td>IAH</td><td>NA</td><td>NULL</td><td>TPE</td><td>06:00+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td>FALSE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
</tbody>
</table>




<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>'America/Los_Angeles'</li><li>'America/Los_Angeles'</li><li>'America/Los_Angeles'</li></ol>




<style>
.list-inline {list-style: none; margin:0; padding: 0}
.list-inline>li {display: inline-block}
.list-inline>li:not(:last-child)::after {content: "\00b7"; padding: 0 .5ex}
</style>
<ol class=list-inline><li>'America/New_York'</li><li>'America/New_York'</li><li>'America/New_York'</li></ol>



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


<table class="dataframe">
<caption>A grouped_df: 18 × 24</caption>
<thead>
	<tr><th scope=col>AirlineID</th><th scope=col>ScheduleStartDate</th><th scope=col>ScheduleEndDate</th><th scope=col>FlightNumber</th><th scope=col>DepartureAirportID</th><th scope=col>DepartureTime</th><th scope=col>CodeShare</th><th scope=col>ArrivalAirportID</th><th scope=col>ArrivalTime</th><th scope=col>Monday</th><th scope=col>⋯</th><th scope=col>Saturday</th><th scope=col>Sunday</th><th scope=col>UpdateTime</th><th scope=col>VersionID</th><th scope=col>Terminal</th><th scope=col>num_codeShare</th><th scope=col>DepartureTimeZone</th><th scope=col>ArrivalTimeZone</th><th scope=col>DepartTaiwan</th><th scope=col>ArriveTaiwan</th></tr>
	<tr><th scope=col>&lt;fct&gt;</th><th scope=col>&lt;date&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;list&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>⋯</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;lgl&gt;</th></tr>
</thead>
<tbody>
	<tr><td>BR</td><td>2023-10-09</td><td>2023-10-15</td><td>BR051 </td><td>IAH</td><td>NA</td><td>NULL</td><td>TPE</td><td>06:00+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>BR</td><td>2023-10-16</td><td>2023-10-22</td><td>BR051 </td><td>IAH</td><td>NA</td><td>NULL</td><td>TPE</td><td>06:00+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>BR</td><td>2023-10-23</td><td>2023-10-28</td><td>BR051 </td><td>IAH</td><td>NA</td><td>NULL</td><td>TPE</td><td>06:00+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td>FALSE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>BR</td><td>2023-10-09</td><td>2023-10-15</td><td>BR055 </td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>BR</td><td>2023-10-16</td><td>2023-10-22</td><td>BR055 </td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>BR</td><td>2023-10-23</td><td>2023-10-28</td><td>BR055 </td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td>FALSE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>CM</td><td>2023-10-09</td><td>2023-10-15</td><td>CM8019</td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>CM</td><td>2023-10-16</td><td>2023-10-22</td><td>CM8019</td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>CM</td><td>2023-10-23</td><td>2023-10-28</td><td>CM8019</td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td>FALSE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>SQ</td><td>2023-10-09</td><td>2023-10-15</td><td>SQ5821</td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>SQ</td><td>2023-10-16</td><td>2023-10-22</td><td>SQ5821</td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>SQ</td><td>2023-10-23</td><td>2023-10-28</td><td>SQ5821</td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td>FALSE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>TG</td><td>2023-10-09</td><td>2023-10-15</td><td>TG6265</td><td>IAH</td><td>NA</td><td>NULL</td><td>TPE</td><td>06:00+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>TG</td><td>2023-10-16</td><td>2023-10-22</td><td>TG6265</td><td>IAH</td><td>NA</td><td>NULL</td><td>TPE</td><td>06:00+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>TG</td><td>2023-10-23</td><td>2023-10-28</td><td>TG6265</td><td>IAH</td><td>NA</td><td>NULL</td><td>TPE</td><td>06:00+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td>FALSE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>TG</td><td>2023-10-09</td><td>2023-10-15</td><td>TG6273</td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>TG</td><td>2023-10-16</td><td>2023-10-22</td><td>TG6273</td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td> TRUE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
	<tr><td>TG</td><td>2023-10-23</td><td>2023-10-28</td><td>TG6273</td><td>ORD</td><td>NA</td><td>NULL</td><td>TPE</td><td>05:25+1</td><td>TRUE</td><td>⋯</td><td>TRUE</td><td>FALSE</td><td>2023-10-10T08:26:07+08:00</td><td>1111</td><td>2</td><td>0</td><td>America/Chicago</td><td>Asia/Taipei</td><td>FALSE</td><td>TRUE</td></tr>
</tbody>
</table>



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

