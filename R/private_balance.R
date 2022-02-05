private_balance <- function(exchange, dry_run = FALSE) {
  exchange <- tolower(exchange)

  base_url <- get_base_url(exchange)

  path_append <- get_path_append(exchange, "private_balance")

  req_headers <- get_req_headers(exchange, "private_balance")

  req_url <- paste0(base_url, "/", path_append, "/")
  req_url <- paste0("https://api.pro.coinbase.com", "/", path_append, "/")
  # req_url
  #
  timestamp <- format(as.numeric(Sys.time()), digits = 13)
  # key <- RCurl::base64Decode(Sys.getenv(COINBASE-PRO_SECRET), mode = "raw")
  key <- RCurl::base64Decode(Sys.getenv("COINBASE_SECRET_DEFAULT"), mode = "raw")
  method <- "GET"
  what <- paste0(timestamp, method, paste0("/", path_append, "/"))

  sign <- RCurl::base64Encode(digest::hmac(key, what, algo = "sha256", raw = TRUE))
  # req_headers <- c(
  #   # 'CB-ACCESS-KEY' = Sys.getenv(COINBASE-PRO_API),
  #      'CB-ACCESS-KEY' = Sys.getenv("COINBASE_API_DEFAULT"),
  #      'CB-ACCESS-SIGN' = sign,
  #      'CB-ACCESS-TIMESTAMP' = timestamp,
  #      # 'CB-ACCESS-PASSPHRASE' = Sys.getenv(COINBASE-PRO_PASSPHRASE),
  #      'CB-ACCESS-PASSPHRASE' = Sys.getenv("COINBASE_PASSPHRASE_DEFAULT"),
  #      'Content-Type' = 'application/json'
  # )

  httpheader <- c(
    'CB-ACCESS-KEY' = Sys.getenv("COINBASE_API_DEFAULT"),
    'CB-ACCESS-SIGN' = sign,
    'CB-ACCESS-TIMESTAMP' = timestamp,
    'CB-ACCESS-PASSPHRASE' = Sys.getenv("COINBASE_PASSPHRASE_DEFAULT"),
    'Content-Type' = 'application/json'
  )


  # Generating GET results
  httr::content(httr::GET(req_url, httr::add_headers(httpheader)))

  # httr2::request(base_url) %>%
  #   httr2::req_user_agent("cryptoapi (https://github.com/cstjohn810/cryptoapi)") %>%
  #   httr2::req_url_path_append(path_append) %>%
  # #   # httr2::req_url_query(!!!query_params) %>%
  #   httr2::req_headers(!!!req_headers) %>%
  #   httr2::req_dry_run() #%>%
    # httr2::req_perform() %>%
    # httr2::resp_body_json()

  # req_headers

  # query_params <- get_query_params(exchange, "private_balance")

  # resp <- get_api_response(base_url, path_append, dry_run = dry_run)
  #
  # if(dry_run == TRUE) {
  #   resp
  # } else {
  #   get_tidy_resp(exchange, "private_balance", resp = resp)
  # }
}
