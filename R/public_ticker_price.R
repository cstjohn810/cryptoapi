#' GET current public ticker price and market data
#'
#' @param exchange Which exchange to use for price and market data. Choices are "binance", "binance-us", "bittrex", bitstamp", "coinbase",
#'        "coinbase-pro", "crypto.com", "ftx", "ftx-us", "gemini", "huobi", "kraken", "kucoin", and "poloniex".
#' @param base_asset Base asset (default BTC)
#' @param quote_asset Quote asset (default USD)
#' @param price_only If TRUE, only give current price as a numeric vector. If FALSE, give all market data available from API call.
#' @param dry_run If TRUE, call httr2::req_dry_run, which shows the API call without actually sending it.
#' @param ... Query parameters passed to API call
#'
#' @return
#' @export
#'
#' @examples
#' public_ticker_price("binance")
#' public_ticker_price("binance")
#' public_ticker_price("binance-us")
#' public_ticker_price("bitstamp")
#' public_ticker_price("bittrex")
#' public_ticker_price("coinbase")
#' public_ticker_price("coinbase-pro")
#' public_ticker_price("crypto.com")
#' public_ticker_price("ftx")
#' public_ticker_price("ftx-us")
#' public_ticker_price("gemini")
#' public_ticker_price("huobi")
#' public_ticker_price("kraken")
#' public_ticker_price("kucoin")
#' public_ticker_price("poloniex")
public_ticker_price <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", price_only = TRUE, dry_run = FALSE, ...) {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin", "poloniex")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    quote_asset
  }

  base_url <- get_base_url(exchange)

  path_append <- get_path_append(exchange, "public_ticker_price", base_asset, quote_asset)

  query_params <- get_query_params(exchange, "public_ticker_price", base_asset, quote_asset)

  resp <- get_api_response(base_url, path_append, query_params, dry_run)

  if(dry_run == TRUE) {
    resp
  } else if (price_only == FALSE) {
    get_tidy_resp(exchange, "public_ticker_price_addl", base_asset, quote_asset, resp)
  } else {
    get_tidy_resp(exchange, "public_ticker_price", base_asset, quote_asset, resp)
  }
}
