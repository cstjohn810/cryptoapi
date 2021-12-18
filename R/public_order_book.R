#' GET current public order book data
#'
#' @param exchange Which exchange to use for price and market data. Choices are binance, binance-us, bitstamp, coinbase-pro,
#'        crypto.com, ftx, ftx-us, gemini, kraken, and kucoin.
#' @param base_asset Base asset (default BTC)
#' @param quote_asset Quote asset (default USD)
#' @param ... Query parameters passed to API call
#'
#' @return
#' @export
#'
#' @examples public_order_book(exchange = "binance")
public_order_book <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", ...) {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    "USD"
  }

  path_append <- get_path_append(exchange, "public_order_book", base_asset, quote_asset)

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

  # resp

  if (exchange == "binance" | exchange == "binance-us") {
    resp %>%
      purrr::map_dfr(magrittr::extract)

  } else if (exchange == "bitstamp") {
    resp

  } else if(exchange == "coinbase-pro") {
    resp

  } else if(exchange == "crypto.com") {
    resp

  } else if(exchange == "ftx" | exchange == "ftx-us") {
    resp

  } else if(exchange == "gemini") {
    resp

  } else if(exchange == "kraken") {
    resp

  } else if(exchange == "kucoin") {
    resp

  } else {
    resp
  }
}
