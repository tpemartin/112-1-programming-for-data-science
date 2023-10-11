# Load the httr package
library(httr)
source("R/airline_support.R")

# POST: get token ----
cred_file = "tdx_credentials.json"
access_token <- get_token(cred_file = cred_file)

# GET ----

## GET international flights data -----
responseContent <- get_international_flights(access_token)

## Data cleaning ----
responseContent |>
  purrr::map(length) |>
  unlist() -> responseLength

whichIs18 <- which(responseLength == 18)
whichIs19 <- which(responseLength == 19)

responseContent[whichIs18] |>
  purrr::map(
    ~{
      .x$Terminal <- NA
      .x
    }
  ) -> responseContent[whichIs18]

## save as json ----

responseContent |>
  jsonlite::toJSON(auto_unbox = T) |>
  xfun::write_utf8("data/international_flights.json")

## import in obo format
flights_obo <- jsonlite::fromJSON("data/flights_obo.json", simplifyDataFrame = F)

## import in fbf format ----
flights_json <- jsonlite::fromJSON("data/flights_obo.json")

## convert to data frame -----
flights_international <-
  list2DF(
    purrr::transpose(responseContent)
)

## check code_share -----
responseContent[[1]]$CodeShare |>
  length()

responseContent |>
  purrr::map_int(
    ~{
      .x$CodeShare |>
        length()
    }
  ) -> codeShareLength

table(codeShareLength)

flights_international |>
  dplyr::mutate(
    num_codeShare = codeShareLength
  ) -> flights

## Check num_codeShare == 2

flights |>
  dplyr::filter(
    num_codeShare ==2
  ) -> flights_codeShare


