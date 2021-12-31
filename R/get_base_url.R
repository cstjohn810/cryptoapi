#' Lookup function for REST API base endpoint URL
#'
#' @param exchange Which exchange to use
#'
#' @return
#'
get_base_url <- function(exchange) {
  dplyr::case_when(
    exchange == "binance" ~  "https://api.binance.com",
    exchange == "binance-us" ~ "https://api.binance.us",
    exchange == "bitstamp" ~  "https://www.bitstamp.net/api/v2",
    exchange == "bittrex" ~ "https://api.bittrex.com/v3",
    exchange == "coinbase" ~  "https://api.coinbase.com/v2",
    exchange == "coinbase-pro" ~  "https://api.exchange.coinbase.com",
    exchange == "crypto.com" ~  "https://api.crypto.com/v2",
    exchange == "ftx" ~ "https://ftx.com/api",
    exchange == "ftx-us" ~ "https://ftx.us/api",
    exchange == "gemini" ~ "https://api.gemini.com",
    exchange == "huobi" ~ "https://api.huobi.pro",
    exchange == "kraken" ~ "https://api.kraken.com/0",
    exchange == "kucoin" ~ "https://api.kucoin.com",
    exchange == "poloniex" ~ "https://poloniex.com",
    TRUE ~ "Unsupported exchange or invalid entry"
  )
}
