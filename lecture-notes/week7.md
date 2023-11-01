```R
# To ensure Chinese characters are displayed correctly
options(encoding = "UTF-8")
Sys.setlocale("LC_CTYPE", "zh_TW.UTF-8")
```

# Read progress file


```R
flights = readRDS("data/flights.rds")
```


```R
str(flights)
```


```R
flights$data[[1]][["meta"]][["name"]]
```


```R
flightsData <- flights$data[[1]][["data_frame"]]
```


```R
flightsData$AirlineID
```

# Preliminary data observations

We need to describe variables in `flightsData` that we want to use in our analysis. 

## AirlineID

- factor data type
  - describe levels
  - table


```R
levels(flightsData$AirlineID) |> length()


```

There are 74 different airlines.
The top 10 operators are:



```R
table(flightsData$AirlineID) |> sort(decreasing = TRUE) |> head(10)
```


```R
dataSummary <- list()

dataSummary$AirlineID <- table(flightsData$AirlineID) |> sort(decreasing = TRUE)
```

 `|>` pipe operator

`a |> fun()` is the same as `fun(a)`
`a |> fun(b)` is the same as `fun(a, b)`

- pipe operator is only for the first argument of a function

What are those airline names? 


```R

data2 <- list(
  meta = list(
    name="航空公司統一代碼",
    source_link ="https://data.gov.tw/dataset/8088"
  ),
  file = "data/airlines.json"
)

flights$data[[2]] <- data2

airlines <-
  jsonlite::fromJSON(
    flights$data[[2]][["file"]]
  )

flights$data[[2]][["data_frame"]] <- airlines

saveRDS(flights, file="flights.rds")
```


```R
dplyr::glimpse(airlines)
```

# Join two data frames

We can `airlines` data into `flightsData` using `AirlineID` variable. We can use `dplyr::left_join` function to do that. 



```R
# dplyr::left_join example

# two data frames
df1 <- data.frame(
  id = c(1, 2, 3, 4, 5),
  name = c("A", "B", "C", "D", "E")
)

df2 <- data.frame(
  id = c(1, 2, 3, 4, 5, 7),
  score = c(90, 80, 70, 60, 50, 40)
)

# join by id
dplyr::left_join(df1, df2, by = "id")

# join by id
df3 <- data.frame(
  ID = c(1, 2, 3, 4, 5, 7),
  score = c(90, 80, 70, 60, 50, 40)
)

# join by df$id and df3$ID
dplyr::left_join(df1, df3, by = c("id" = "ID"))
```


```R
dplyr::left_join(
  flightsData, airlines,
  by="AirlineID"
) -> flightsData

flightsData$AirlineName <-
  factor(
    flightsData[["AirlineName"]]
  )

```

# Departure and Arrival Flights



```R
names(flightsData)
```

If DepartureAirportID belong to Taiwan airport, it is a departure flight. If ArrivalAirportID belong to Taiwan airport, it is an arrival flight.

What are Taiwan's airport IDs?


```R
# airportr package has a airports data frame
install.packages("airportr")
```


```R
airports <- airportr::airports
dplyr::glimpse(airports)
```

# dplyr::filter

Keep those rows of data frame that satisfy a condition.


```R
dplyr::filter(
  airports,
  Country == "Taiwan"
) -> airports_taiwan

head(airports_taiwan)
```

 - `Country == "Taiwan"` is to compare if `Country` variable is equal to `"Taiwan"`.

 - [relational operators](https://tpemartin.github.io/NTPU-R-for-Data-Science-EN/operations-on-atomic-vectors.html#operations-on-atomic-vectors-1)


```R
airports_taiwan$IATA

# keep only unique values
unique(airports_taiwan$IATA)
```


```R
flightsData |>
 dplyr::filter(
    DepartureAirportID %in% unique(airports_taiwan[["IATA"]])) -> 
    departure_flightsData

flightsData |>
  dplyr::filter(
    ArrivalAirportID %in% unique(airports_taiwan[["IATA"]])) -> 
    arrival_flightsData


flights$data[[3]] <- list(
  departure_flightsData= departure_flightsData,
  arrival_flightsData = arrival_flightsData
)


```

- `DepartureAirportID %in% unique(airports_taiwan$IATA)` has `%in%` operator. It is to check if a value is in a vector.


```R
# number of departure flights
nrow(departure_flightsData)

# number of arrival flights
nrow(arrival_flightsData)
```


```R
# Departure/Arrival contribution of each airlines
departure_flightsData$AirlineID |> table() |> sort(decreasing = TRUE) -> 
    dataSummary[["departure"]][["AirlineID"]]
arrival_flightsData$AirlineID |> table() |> sort(decreasing = TRUE) -> 
    dataSummary[["arrival"]][["AirlineID"]]

flights$dataSummary <- dataSummary

saveRDS(flights, file="data/flights.rds")

```
