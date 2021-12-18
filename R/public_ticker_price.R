#' GET current public ticker price and market data
#'
#' @param exchange Which exchange to use for price and market data. Choices are binance, binance-us, bitstamp, coinbase, coinbase-pro,
#'        crypto.com, ftx, ftx-us, gemini, huobi, kraken, and kucoin.
#' @param base_asset Base asset (default BTC)
#' @param quote_asset Quote asset (default USD)
#' @param price_only If TRUE, only give current price as a numeric vector. If FALSE, give all market data available from API call.
#' @param ... Query parameters passed to API call
#'
#' @return
#' @export
#' @importFrom magrittr `%>%`
#'
#' @examples public_ticker_price("binance")
#' @examples public_ticker_price("binance")
#' @examples public_ticker_price("binance-us")
#' @examples public_ticker_price("bitstamp")
#' @examples public_ticker_price("coinbase")
#' @examples public_ticker_price("coinbase-pro")
#' @examples public_ticker_price("crypto.com")
#' @examples public_ticker_price("ftx")
#' @examples public_ticker_price("ftx-us")
#' @examples public_ticker_price("gemini")
#' @examples public_ticker_price("huobi")
#' @examples public_ticker_price("kraken")
#' @examples public_ticker_price("kucoin")
public_ticker_price <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", price_only = TRUE, ...) {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    "USD"
  }

  path_append <- get_path_append(exchange, "public_ticker_price", base_asset, quote_asset)

  query_params <- if(exchange == "binance" | exchange == "binance-us") {
    list(
      ...,
      symbol = paste0(base_asset, quote_asset)
    )
  } else if(exchange == "crypto.com") {
    list(
      ...,
      instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset))
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

  if(price_only == FALSE){
    resp

  } else if (exchange == "bitstamp") {
    resp %>%
      tibble::as_tibble() %>%
      dplyr::pull(last) %>%
      as.numeric()

  } else if (exchange == "binance" | exchange == "binance-us") {
    resp %>%
      tibble::as_tibble() %>%
      dplyr::pull(price) %>%
      as.numeric()

  } else if(exchange == "coinbase") {
    resp$data$amount %>%
      as.numeric()

  } else if(exchange == "coinbase-pro") {
    resp$price %>%
      as.numeric()

  } else if(exchange == "crypto.com") {
    resp$result$data$a

  } else if(exchange == "ftx" | exchange == "ftx-us") {
    resp$result$price

  } else if(exchange == "gemini") {
    resp$close %>%
      as.numeric()

  } else if(exchange == "huobi") {
    resp$tick$data[[1]]$price

  } else if(exchange == "kraken") {
    resp$result$XXBTZUSD$p[[1]] %>%
      as.numeric()

  } else if(exchange == "kucoin") {
    resp$data$price %>%
      as.numeric()

  } else {
    resp
  }
}



