#' Lookup function for REST API URL path appends
#'
#' @param exchange Which exchange
#' @param fn Which function needs a path append
#' @param base_asset Base asset
#' @param quote_asset Quote asset
#'
#' @return
#'
#' @examples
get_path_append <- function(exchange, fn, base_asset = NULL, quote_asset = NULL) {
  dplyr::case_when(

    (exchange == "binance" | exchange == "binance-us") & fn == "public_ticker_price" ~  "api/v3/ticker/price",
    exchange == "bitstamp" & fn == "public_ticker_price" ~  paste0("ticker/", tolower(base_asset), tolower(quote_asset)),
    exchange == "coinbase" & fn == "public_ticker_price" ~  paste0("prices/", base_asset, "-", quote_asset, "/spot"),
    exchange == "coinbase-pro" & fn == "public_ticker_price" ~  paste0("products/", base_asset, "-", quote_asset, "/ticker"),
    exchange == "crypto.com" & fn == "public_ticker_price" ~  "public/get-ticker",
    (exchange == "ftx" | exchange == "ftx-us") & fn == "public_ticker_price" ~ paste0("markets/", base_asset, "/", quote_asset),
    exchange == "gemini" & fn == "public_ticker_price" ~ paste0("v2/ticker/", base_asset, quote_asset),
    exchange == "huobi" & fn == "public_ticker_price" ~ "market/trade",
    exchange == "kraken" & fn == "public_ticker_price" ~ "public/Ticker",
    exchange == "kucoin" & fn == "public_ticker_price" ~ "api/v1/market/orderbook/level1",

    (exchange == "binance" | exchange == "binance-us") & fn == "public_asset_list" ~  "api/v3/exchangeInfo",
    exchange == "bitstamp" & fn == "public_asset_list" ~  "trading-pairs-info",
    exchange == "coinbase" & fn == "public_asset_list" ~  "currencies",
    exchange == "coinbase-pro" & fn == "public_asset_list" ~  "products",
    exchange == "crypto.com" & fn == "public_asset_list" ~  "public/get-instruments",
    (exchange == "ftx" | exchange == "ftx-us") & fn == "public_asset_list" ~ "markets",
    exchange == "gemini" & fn == "public_asset_list" ~ "v1/symbols",
    exchange == "huobi" & fn == "public_asset_list" ~ "v1/common/symbols",
    exchange == "kraken" & fn == "public_asset_list" ~ "public/Assets",
    exchange == "kucoin" & fn == "public_asset_list" ~ "api/v1/symbols",

    TRUE ~ "Unsupported exchange or invalid entry"
  )
}
