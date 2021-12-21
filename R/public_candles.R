#' GET Candlestick/Kline/OHLC data
#'
#' @param exchange Which exchange to use for price and market data.
#'        Choices are "binance", "binance-us", "bitstamp", "coinbase-pro", "crypto.com", "ftx", "ftx-us", "gemini",
#'        "huobi", "kraken", and "kucoin".
#' @param base_asset Base asset (default "BTC")
#' @param quote_asset Quote asset (default "USD")
#' @param ... Query parameters passed to API call
#' @param time_frame Parameter used for chart interval and timeframe.
#'        \itemize{
#'         \item Required for "binance" and "binance-us".
#'               Possible options are "1m", "3m", "5m", "15m", "30m", "1h", "2h", "4h", "6h", "8h", "12h", "1d", "3d", "1w", "1M"
#'         \item Required for "bitstamp". Timeframe in seconds.
#'               Possible options are 60, 180, 300, 900, 1800, 3600, 7200, 14400, 21600, 43200, 86400, 259200
#'         \item Optional for "coinbase-pro".
#'               Possible options are 60, 300, 900, 3600, 21600, 86400. Default 60.
#'               These values correspond to timeslices representing one minute, five minutes,
#'               fifteen minutes, one hour, six hours, and one day, respectively.
#'         \item Required for "crypto.com".
#'               Period can be "1m", "5m", "15m", "30m", "1h", "4h", "6h", "12h", "1D", "7D", "14D", or "1M"
#'         \item Required for "ftx" and "ftx-us". Window length in seconds.
#'               Options: 15, 60, 300, 900, 3600, 14400, 86400, or any multiple of 86400 up to 30*86400
#'        }
#' @param start_time Parameter used for chart beginning time.
#'        \itemize{
#'         \item Optional for "binance" and "binance-us" in long time format
#'               If startTime and endTime are not sent, the most recent klines are returned.
#'         \item Optional for "bitstamp". Unix timestamp from when OHLC data will be started.
#'         \item Optional for "coinbase-pro". The maximum number of data points for a single request is 300 candles.
#'               If either one of the start or end fields are not provided then both fields will be ignored.
#'               If a custom time range is not declared then one ending now is selected.
#'         \item Optional for "ftx" and "ftx-us". Must specify both start_time and end_time for historical prices.
#'         }
#' @param end_time Parameter used for chart end time.
#'        \itemize{
#'         \item Optional for "binance" and "binance-us" in long time format
#'               If startTime and endTime are not sent, the most recent klines are returned.
#'         \item Optional for "bitstamp". Unix timestamp to when OHLC data will be shown.
#'         \item Optional for "coinbase-pro". The maximum number of data points for a single request is 300 candles.
#'               If either one of the start or end fields are not provided then both fields will be ignored.
#'               If a custom time range is not declared then one ending now is selected.
#'         \item Optional for "ftx" and "ftx-us". Must specify both start_time and end_time for historical prices.
#'         }
#' @param limit Parameter used to limit number of candles.
#'        \itemize{
#'         \item Optional for "binance" and "binance-us". Default 500; max 1000.
#'         \item Required for "bitstamp". Minimum: 1; maximum: 1000
#'         }
#' @return
#' @export
#'
#' @examples public_candles("binance", time_frame = "1m")
#' @examples public_candles("bitstamp", time_frame = 60, limit = 1)
#' @examples public_candles("coinbase-pro")
#' @examples public_candles("ftx", time_frame = 60)
#' @examples public_candles("ftx-us", time_frame = 60)
public_candles <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", ..., time_frame = NULL,
                           start_time = NULL, end_time = NULL, limit = NULL) {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    "USD"
  }

  path_append <- get_path_append(exchange, "public_candles", base_asset, quote_asset, time_frame)

  query_params <- if(exchange == "binance" | exchange == "binance-us") {
    list(
      ...,
      symbol = paste0(base_asset, quote_asset),
      interval = time_frame,
      start_time = start_time,
      end_time = end_time,
      limit = limit
    )
  } else if(exchange == "bitstamp") {
    list(
      ...,
      start = start_time,
      end = end_time,
      step = time_frame,
      limit = limit
    )
  } else if(exchange == "coinbase-pro") {
    list(
      ...,
      start = start_time,
      end = end_time,
      granularity = time_frame
    )
  } else if(exchange == "crypto.com") {
    list(
      ...,
      instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)),
      timeframe = time_frame
    )
  } else if(exchange == "ftx" | exchange == "ftx-us") {
    list(
      ...,
      start_time = start_time,
      end_time = end_time,
      resolution = time_frame
    )
  } else if(exchange == "huobi") {
    list(
      ...,
      symbol = paste0(tolower(base_asset), tolower(quote_asset))
    )
  } else if(exchange == "kraken") {
    list(
      ...,
      pair = paste0(base_asset, quote_asset)
    )
  } else if(exchange == "kucoin")
    list(
      ...,
      symbol = paste0(toupper(base_asset), "-", toupper(quote_asset))
    )
  else {
    NULL
  }

  resp <- httr2::request(get_base_url(exchange)) %>%
    httr2::req_user_agent("cryptoapi (https://github.com/cstjohn810/cryptoapi)") %>%
    httr2::req_url_path_append(path_append) %>%
    httr2::req_url_query(!!!query_params) %>%
    # httr2::req_dry_run()
  httr2::req_perform() %>%
  httr2::resp_body_json()

  resp

  # if (exchange == "binance" | exchange == "binance-us") {
  #   resp %>%
  #     purrr::map_dfr(magrittr::extract) %>%
  #     dplyr::pull(price) %>%
  #     as.numeric()
  #
  # } else if (exchange == "bitstamp") {
  #   resp %>%
  #     purrr::map_dfr(magrittr::extract) %>%
  #     dplyr::pull(last) %>%
  #     as.numeric()
  #
  # } else if (exchange == "coinbase") {
  #   resp %>%
  #     purrr::map_dfr(magrittr::extract) %>%
  #     dplyr::pull(amount) %>%
  #     as.numeric()
  #
  # } else if (exchange == "coinbase-pro") {
  #   resp %>%
  #     purrr::map_dfr(magrittr::extract) %>%
  #     dplyr::pull(price) %>%
  #     as.numeric()
  #
  # } else if (exchange == "crypto.com") {
  #   resp$result$data$a
  #
  # } else if (exchange == "ftx" | exchange == "ftx-us") {
  #   resp$result$price
  #
  # } else if (exchange == "gemini") {
  #   resp$close %>%
  #     as.numeric()
  #
  # } else if (exchange == "huobi") {
  #   resp$tick$data[[1]]$price
  #
  # } else if (exchange == "kraken") {
  #   resp$result[[1]]$p[1] %>%
  #     as.numeric()
  #
  # } else if (exchange == "kucoin") {
  #   resp$data$price %>%
  #     as.numeric()
  #
  # } else {
  #   resp
  # }
}
