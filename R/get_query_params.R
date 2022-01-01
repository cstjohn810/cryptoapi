#' Lookup function for REST API URL query parameters
#'
#' @param exchange Which exchange
#' @param fn Which function needs a query
#' @param base_asset Base asset
#' @param quote_asset Quote asset
#' @param ... Additional parameters to pass to API call
#' @param level Parameter used for varying aggregations of order book.
#' @param depth Optional parameter used to specify number of bids and asks to return.
#' @param time_frame Parameter used for chart interval and timeframe.
#' @param start_time Parameter used for chart beginning time.
#' @param end_time Parameter used for chart end time.
#' @param limit Parameter used to limit number of candles.
#' @param candle_type Type of candles.
#'
#' @return
#'
get_query_params <- function(exchange, fn, base_asset = NULL, quote_asset = NULL, ..., level = NULL, depth = NULL, time_frame = NULL,
                             start_time = NULL, end_time = NULL, limit = NULL, candle_type = NULL) {


# public_ticker_price ----

  if ((exchange == "binance" | exchange == "binance-us") & fn == "public_ticker_price") {
    list(...,
         symbol = paste0(base_asset, quote_asset))

  } else if (exchange == "crypto.com" & fn == "public_ticker_price") {
    list(...,
         instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)))

  } else if (exchange == "huobi" & fn == "public_ticker_price") {
    list(...,
         symbol = paste0(tolower(base_asset), tolower(quote_asset)))

  } else if (exchange == "kraken" & fn == "public_ticker_price") {
    list(...,
         pair = paste0(base_asset, quote_asset))

  } else if (exchange == "kucoin" & fn == "public_ticker_price") {
    list(...,
         symbol = paste0(toupper(base_asset), "-", toupper(quote_asset)))

  } else if (exchange == "poloniex" & fn == "public_ticker_price") {
    list(...,
         command = "returnTicker")

  }

# public_asset_list ----
  else if (exchange == "poloniex" & fn == "public_asset_list") {
    list(...,
         command = "returnTicker")

  }

# public_order_book ----
  else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_order_book") {
    list(...,
         symbol = paste0(base_asset, quote_asset),
         limit = depth)

  } else if (exchange == "bitstamp" & fn == "public_order_book") {
    list(...,
         group = level)

  } else if (exchange == "bittrex" & fn == "public_order_book") {
    list(...,
         depth = depth)

  } else if (exchange == "coinbase-pro" & fn == "public_order_book") {
    list(...,
         level = level)

  } else if (exchange == "crypto.com" & fn == "public_order_book") {
    list(...,
         instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)),
         depth = depth)

  } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_order_book") {
    list(...,
         depth = depth)

  } else if (exchange == "gemini" & fn == "public_order_book") {
    list(...,
         limit_bids = depth,
         limit_asks = depth)

  } else if (exchange == "huobi" & fn == "public_order_book") {
    list(...,
         symbol = paste0(tolower(base_asset), tolower(quote_asset)),
         type = level)

  } else if (exchange == "kraken" & fn == "public_order_book") {
    list(...,
         pair = paste0(base_asset, quote_asset),
         count = depth)

  } else if (exchange == "kucoin" & fn == "public_order_book") {
    list(...,
         symbol = paste0(toupper(base_asset), "-", toupper(quote_asset)))

  } else if (exchange == "poloniex" & fn == "public_order_book") {
    list(...,
         command = "returnOrderBook",
         currencyPair = paste0(toupper(quote_asset), "_", toupper(base_asset)),
         depth = depth)

  }

# public_candles ----
  else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_candles") {
    list(...,
         symbol = paste0(base_asset, quote_asset),
         interval = time_frame,
         start_time = start_time,
         end_time = end_time,
         limit = limit)

  } else if (exchange == "bitstamp" & fn == "public_candles") {
    list(...,
         start = start_time,
         end = end_time,
         step = time_frame,
         limit = limit)

  } else if (exchange == "coinbase-pro" & fn == "public_candles") {
    list(...,
         start = start_time,
         end = end_time,
         granularity = time_frame)

  } else if (exchange == "crypto.com" & fn == "public_candles") {
    list(...,
         instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)),
         timeframe = time_frame)

  } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_candles") {
    list(...,
         start_time = start_time,
         end_time = end_time,
         resolution = time_frame)

  } else if (exchange == "huobi" & fn == "public_candles") {
    list(...,
         symbol = paste0(tolower(base_asset), tolower(quote_asset)),
         period = time_frame,
         size = limit)

  } else if (exchange == "kraken" & fn == "public_candles") {
    list(...,
         pair = paste0(base_asset, quote_asset),
         interval = time_frame,
         since = start_time)

  } else if (exchange == "kucoin" & fn == "public_candles") {
    list(...,
         symbol = paste0(toupper(base_asset), "-", toupper(quote_asset)),
         startAt = start_time,
         endAt = end_time,
         type = time_frame)

  } else if (exchange == "poloniex" & fn == "public_candles") {
    list(...,
         command = "returnChartData",
         currencyPair = paste0(toupper(quote_asset), "_", toupper(base_asset)),
         start = start_time,
         end = end_time,
         period = time_frame)

  }

# public_trades ----
  else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_trades") {
    list(...,
         symbol = paste0(base_asset, quote_asset),
         limit = limit)

  } else if (exchange == "bitstamp" & fn == "public_trades") {
    list(...,
         time = time_frame)

  } else if (exchange == "coinbase-pro" & fn == "public_trades") {
    list(...,
         limit = limit)

  } else if (exchange == "crypto.com" & fn == "public_trades") {
    list(...,
         instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)))

  } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_trades") {
    list(...,
         start_time = start_time,
         end_time = end_time)

  } else if (exchange == "gemini" & fn == "public_trades") {
    list(...,
         limit_trades = limit,
         timestamp = start_time)

  } else if (exchange == "huobi" & fn == "public_trades") {
    list(...,
         symbol = paste0(tolower(base_asset), tolower(quote_asset)),
         size = limit)

  } else if (exchange == "kraken" & fn == "public_trades") {
    list(...,
         pair = paste0(base_asset, quote_asset))

  } else if (exchange == "kucoin" & fn == "public_trades") {
    list(...,
         symbol = paste0(toupper(base_asset), "-", toupper(quote_asset)))

  } else if (exchange == "poloniex" & fn == "public_trades") {
    list(...,
         command = "returnTradeHistory",
         currencyPair = paste0(toupper(quote_asset), "_", toupper(base_asset)),
         start = start_time,
         end = end_time)

  }

# public_asset_info ----


# else ----
  else {
    NULL
  }
}
