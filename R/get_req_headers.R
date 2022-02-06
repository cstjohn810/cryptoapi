get_req_headers <- function(exchange, portfolio = NULL, fn, base_asset = NULL, quote_asset = NULL, ...) {
  if ((exchange == "binance" | exchange == "binance-us")) {
    exchange

  # } else if (exchange == "bitstamp") {
  #   exchange
  #
  # } else if (exchange == "bittrex") {
  #   exchange
  #
  # } else if (exchange == "coinbase") {
  #   exchange

  } else if (exchange == "coinbase-pro") {

    public_var <- toupper(paste(exchange, "api", portfolio, sep = "_"))
    secret_var <- toupper(paste(exchange, "secret", portfolio, sep = "_"))
    passphrase_var <- toupper(paste(exchange, "passphrase", portfolio, sep = "_"))

    req_url <- paste0("/", get_path_append(exchange, fn, base_asset, quote_asset), "/")
    req_url

    timestamp <- format(as.numeric(Sys.time()), digits = 13)
    key <- RCurl::base64Decode(Sys.getenv(secret_var), mode = "raw")
    method <- "GET"
    what <- paste0(timestamp, method, req_url)

    sign <- RCurl::base64Encode(digest::hmac(key, what, algo = "sha256", raw = TRUE))
    c('CB-ACCESS-KEY' = Sys.getenv(public_var),
      'CB-ACCESS-SIGN' = sign,
      'CB-ACCESS-TIMESTAMP' = timestamp,
      'CB-ACCESS-PASSPHRASE' = Sys.getenv(passphrase_var),
      'Content-Type' = 'application/json'
    )

  }
    # else if (exchange == "crypto.com") {
  #   list(...,
  #        instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)))
  #
  # } else if (exchange == "ftx" | exchange == "ftx-us") {
  #   list(...,
  #        instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)))
  #
  # } else if (exchange == "gemini") {
  #   list(...,
  #        symbol = paste0(tolower(base_asset), tolower(quote_asset)))
  #
  # } else if (exchange == "huobi") {
  #   list(...,
  #        symbol = paste0(tolower(base_asset), tolower(quote_asset)))
  #
  # } else if (exchange == "kraken") {
  #   list(...,
  #        pair = paste0(base_asset, quote_asset))
  #
  # } else if (exchange == "kucoin") {
  #   list(...,
  #        symbol = paste0(toupper(base_asset), "-", toupper(quote_asset)))
  #
  # } else if (exchange == "poloniex") {
  #   list(...,
  #        command = "returnTicker")
  #
  # }
    else {
      exchange
    }
}
