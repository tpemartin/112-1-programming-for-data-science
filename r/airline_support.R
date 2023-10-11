get_token <- function(cred_file = "tdx_credentials.json") {

  cred <- jsonlite::fromJSON(cred_file)

  # Define the URL
  url <- "https://tdx.transportdata.tw/auth/realms/TDXConnect/protocol/openid-connect/token"

  # Define the headers
  headers <- c("Content-Type" = "application/x-www-form-urlencoded")

  # Define the body data
  body <- list(
    grant_type = "client_credentials",
    client_id = cred$client_id,
    client_secret = cred$client_secret
  )

  # Make the POST request
  token <- POST(url, add_headers(.headers=headers), body = body, encode = "form")
  tokenContent <- httr::content(token)
  access_token <- tokenContent$access_token
  access_token
}
get_international_flights <- function(access_token) {
  # Define the URL
  url <- "https://tdx.transportdata.tw/api/basic/v2/Air/GeneralSchedule/International?%24format=JSON"

  # Define headers
  headers <- c("Accept" = "application/json",
               "Authorization" = glue::glue("Bearer {access_token}"))

  # Make the GET request
  response <- GET(url, add_headers(.headers=headers),
                  query=list(
                    top=5000
                  ))

  responseContent <- httr::content(response)
  responseContent
}
