#' GET Candlestick/Kline/OHLC data
#'
#' @param exchange Which exchange to use for price and market data.
#'        Choices are "binance", "binance-us", "bitstamp", "bittrex", "coinbase-pro", "crypto.com", "ftx", "ftx-us", "gemini",
#'        "huobi", "kraken","kucoin", and "poloniex".
#' @param base_asset Base asset (default "BTC")
#' @param quote_asset Quote asset (default "USD")
#' @param ... Query parameters passed to API call
#' @param time_frame Parameter used for chart interval and timeframe.
#'        \itemize{
#'         \item Required for "binance" and "binance-us".
#'               Possible options are "1m", "3m", "5m", "15m", "30m", "1h", "2h", "4h", "6h", "8h", "12h", "1d", "3d", "1w", "1M"
#'         \item Required for "bitstamp". Timeframe in seconds.
#'               Possible options are 60, 180, 300, 900, 1800, 3600, 7200, 14400, 21600, 43200, 86400, 259200
#'         \item Required for "bittrex". Desired time interval between candles
#'               Options: "MINUTE_1", "MINUTE_5", "HOUR_1", "DAY_1"
#'         \item Optional for "coinbase-pro".
#'               Possible options are 60, 300, 900, 3600, 21600, 86400. Default 60.
#'               These values correspond to time slices representing one minute, five minutes,
#'               fifteen minutes, one hour, six hours, and one day, respectively.
#'         \item Required for "crypto.com".
#'               Period can be "1m", "5m", "15m", "30m", "1h", "4h", "6h", "12h", "1D", "7D", "14D", or "1M"
#'         \item Required for "ftx" and "ftx-us". Window length in seconds.
#'               Options: 15, 60, 300, 900, 3600, 14400, 86400, or any multiple of 86400 up to 30*86400
#'         \item Required for "gemini".
#'               Options: "1m", "5m", "15m", "30m", "1hr", "6hr", "1day".
#'         \item Required for "huobi".
#'               Options: "1min", "5min", "15min", "30min", "60min", "4hour", "1day", "1mon", "1week", "1year".
#'         \item Optional for "kraken". Time frame interval in minutes. Default 1.
#'               Options: 1, 5, 15, 30, 60, 240, 1440, 10080, 21600.
#'         \item Required for "kucoin".
#'               Options: "1min", "3min", "5min", "15min", "30min", "1hour", "2hour", "4hour", "6hour", "8hour", "12hour", "1day", "1week".
#'         \item Required for "poloniex". Candlestick period in seconds
#'               Options: 300, 900, 1800, 7200, 14400, 86400.
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
#'         \item Optional for "kucoin". For each query, the system would return at most 1500 pieces of data.
#'               To obtain more data, please page the data by time.
#'         \item Required for "poloniex". The start of the window in seconds since the unix epoch.
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
#'         \item Optional for "kucoin". For each query, the system would return at most 1500 pieces of data.
#'               To obtain more data, please page the data by time.
#'         \item Required for "poloniex". The end of the window in seconds since the unix epoch.
#'         }
#' @param limit Parameter used to limit number of candles.
#'        \itemize{
#'         \item Optional for "binance" and "binance-us". Default: 500; Maximum: 1000.
#'         \item Required for "bitstamp". Minimum: 1; Maximum: 1000
#'         \item Optional for "huobi". Default: 150; Minimum: 1; Maximum: 2000.
#'         }
#' @param candle_type Type of candles.
#'        \itemize{
#'         \item Optional for "bittrex". This portion of the url may be omitted if trade based candles are desired.
#'               Options: "TRADE" or "MIDPOINT"
#'         }
#' @return
#' @export
#'
#' @examples
#' public_candles("binance", time_frame = "1m")
#' public_candles("bitstamp", time_frame = 60, limit = 1)
#' public_candles("bittrex", time_frame = "MINUTE_1")
#' public_candles("coinbase-pro")
#' public_candles("ftx", time_frame = 60)
#' public_candles("ftx-us", time_frame = 60)
#' public_candles("gemini", time_frame = "1m")
#' public_candles("huobi", time_frame = "1min")
#' public_candles("kraken")
#' public_candles("kucoin", time_frame = "1min")
#' public_candles("poloniex", time_frame = 300, start_time = 1546300800, end_time = 1546646400)
public_candles <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", ..., time_frame = NULL,
                           start_time = NULL, end_time = NULL, limit = NULL, candle_type = NULL) {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin", "poloniex")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    quote_asset
  }

  candle_type <- if(is.null(candle_type)) NULL else(paste0(candle_type, "/"))

  base_url <- get_base_url(exchange)

  path_append <- get_path_append(exchange, "public_candles", base_asset, quote_asset, time_frame, candle_type)

  query_params <- get_query_params(exchange, "public_candles", base_asset, quote_asset, ..., time_frame = time_frame, start_time = start_time,
                                   end_time = end_time, limit = limit, candle_type = candle_type)


  resp <- httr2::request(base_url) %>%
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
