#' GET recent trades
#'
#' @param exchange Which exchange to use for price and market data. Choices are "binance", "binance-us", "bittrex", bitstamp", "coinbase",
#'        "coinbase-pro", "crypto.com", "ftx", "ftx-us", "gemini", "huobi", "kraken", "kucoin", and "poloniex".
#' @param base_asset Base asset (default BTC)
#' @param quote_asset Quote asset (default USD)
#' @param dry_run If TRUE, call httr2::req_dry_run, which shows the API call without actually sending it.
#' @param ... Query parameters passed to API call
#' @param limit Parameter used to limit number of trades.
#'        \itemize{
#'         \item Optional for "binance" and "binance-us". Default: 500; Maximum: 1000.
#'         \item Optional for "coinbase-pro". Default: 1000; Maximum: 1000.
#'         \item Optional for "gemini". Default: 50; Maximum: 500.
#'         \item Optional for "huobi". Default: 1; Maximum: 2000.
#'         }
#' @param time_frame Parameter used for trade interval and timeframe.
#'        \itemize{
#'         \item Optional for "bitstamp". The time interval from which we want the transactions to be returned.
#'               Default: "day". Possible options are "minute", "hour", or "day".
#'        }
#' @param start_time Parameter used for trade beginning time.
#'        \itemize{
#'         \item Optional for "ftx" and "ftx-us".
#'         \item Optional for "gemini". Only return trades after this timestamp. If not present, will show the most recent trades.
#'         \item Optional for "kraken".
#'         \item Optional for "poloniex". Return up to 1,000 trades between a range specified in UNIX timestamps.
#'        }
#' @param end_time Parameter used for trade end time.
#'        \itemize{
#'         \item Optional for "ftx" and "ftx-us".
#'         \item Optional for "poloniex". Return up to 1,000 trades between a range specified in UNIX timestamps.
#'        }
#'
#' @return
#' @export
#'
#' @examples
#' public_trades("binance")
#' public_trades("binance-us")
#' public_trades("bitstamp")
#' public_trades("bittrex")
#' public_trades("coinbase-pro")
#' public_trades("crypto.com")
#' public_trades("ftx")
#' public_trades("ftx-us")
#' public_trades("gemini")
#' public_trades("huobi")
#' public_trades("kraken")
#' public_trades("kucoin")
#' public_trades("poloniex")
public_trades <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", dry_run = FALSE, ..., limit = NULL,
                          time_frame = NULL, start_time = NULL, end_time = NULL) {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin", "poloniex")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    quote_asset
  }

  base_url <- get_base_url(exchange)

  path_append <- get_path_append(exchange, "public_trades", base_asset, quote_asset)

  query_params <- get_query_params(exchange, "public_trades", base_asset, quote_asset, ..., limit = limit,
                                   time_frame = time_frame, start_time = start_time, end_time = end_time)

  resp <- get_api_response(base_url, path_append, query_params, dry_run)

  if(dry_run == TRUE) {
    resp
    } else {
      get_tidy_resp(exchange, "public_trades", base_asset, quote_asset, resp)
    }
}
