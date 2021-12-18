#' Lookup function for REST API URL path appends
#'
#' @param exchange Which exchange
#' @param fn Which function needs a path append
#' @param base_asset Base asset
#' @param quote_asset Quote asset
#'
#' @return
#'
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

    (exchange == "binance" | exchange == "binance-us") & fn == "public_order_book" ~  "api/v3/depth",
    exchange == "bitstamp" & fn == "public_order_book" ~  paste0("order_book/", tolower(base_asset), tolower(quote_asset)),
    exchange == "coinbase-pro" & fn == "public_order_book" ~  paste0("products/", base_asset, "-", quote_asset, "/book"),
    exchange == "crypto.com" & fn == "public_order_book" ~  "public/get-book",
    (exchange == "ftx" | exchange == "ftx-us") & fn == "public_order_book" ~ paste0("markets/", base_asset, "/", quote_asset, "/orderbook"),
    exchange == "gemini" & fn == "public_order_book" ~ paste0("v1/book/", base_asset, quote_asset),
    exchange == "kraken" & fn == "public_order_book" ~ "public/Depth",
    exchange == "kucoin" & fn == "public_order_book" ~ "api/v1/market/orderbook/level2_100",

    (exchange == "binance" | exchange == "binance-us") & fn == "public_candles" ~  "api/v3/klines",
    exchange == "bitstamp" & fn == "public_candles" ~  paste0("ohlc/", tolower(base_asset), tolower(quote_asset)),
    exchange == "coinbase-pro" & fn == "public_candles" ~  paste0("products/", base_asset, "-", quote_asset, "/candles"),
    exchange == "crypto.com" & fn == "public_candles" ~  "public/get-candlestick",
    (exchange == "ftx" | exchange == "ftx-us") & fn == "public_candles" ~ paste0("markets/", base_asset, "/", quote_asset, "/candles"),
    exchange == "gemini" & fn == "public_candles" ~ paste0("v2/candles/", base_asset, quote_asset),
    exchange == "huobi" & fn == "public_candles" ~ "market/history/kline",
    exchange == "kraken" & fn == "public_candles" ~ "public/OHLC",
    exchange == "kucoin" & fn == "public_candles" ~ "api/v1/market/candles",

    (exchange == "binance" | exchange == "binance-us") & fn == "public_trades" ~  "api/v3/trades",
    exchange == "bitstamp" & fn == "public_trades" ~  paste0("transactions/", tolower(base_asset), tolower(quote_asset)),
    exchange == "coinbase-pro" & fn == "public_trades" ~  paste0("products/", base_asset, "-", quote_asset, "/trades"),
    exchange == "crypto.com" & fn == "public_trades" ~  "public/get-trades",
    (exchange == "ftx" | exchange == "ftx-us") & fn == "public_trades" ~ paste0("markets/", base_asset, "/", quote_asset, "/trades"),
    exchange == "gemini" & fn == "public_trades" ~ paste0("v1/trades/", base_asset, quote_asset),
    exchange == "huobi" & fn == "public_trades" ~ "market/history/trade",
    exchange == "kraken" & fn == "public_trades" ~ "public/Trades",
    exchange == "kucoin" & fn == "public_trades" ~ "api/v1/market/histories",

    # (exchange == "binance" | exchange == "binance-us") & fn == "public_asset_info" ~  "api/v1/ticker/bookTicker",
    # exchange == "bitstamp" & fn == "public_asset_info" ~  paste0("asset_info/", tolower(base_asset), tolower(quote_asset)),
    # exchange == "coinbase" & fn == "_asset_info" ~  paste0("prices/", base_asset, "-", quote_asset, "/spot"),
    exchange == "coinbase-pro" & fn == "public_asset_info" ~  paste0("products/", base_asset, "-", quote_asset, "/stats"),
    # exchange == "crypto.com" & fn == "public_asset_info" ~  "public/get-book",
    # (exchange == "ftx" | exchange == "ftx-us") & fn == "public_asset_info" ~ paste0("markets/", base_asset, "/", quote_asset),
    exchange == "gemini" & fn == "public_asset_info" ~ paste0("v1/symbols/details/", base_asset, quote_asset),
    # exchange == "huobi" & fn == "public_asset_info" ~ "v1/common/symbols",
    # exchange == "kraken" & fn == "public_asset_info" ~ "public/Depth",
    exchange == "kucoin" & fn == "public_asset_info" ~ paste0("api/v2/currencies", base_asset),

    TRUE ~ "Unsupported exchange or invalid entry"
  )
}
