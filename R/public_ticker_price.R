#' GET current public ticker price and market data
#'
#' @param exchange Which exchange to use for price and market data. Choices are "binance", "binance-us", "bittrex", bitstamp", "coinbase",
#'        "coinbase-pro", "crypto.com", "ftx", "ftx-us", "gemini", "huobi", "kraken", "kucoin", and "poloniex".
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
public_ticker_price <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", price_only = TRUE, ...) {

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

  resp <- httr2::request(base_url) %>%
  httr2::req_user_agent("cryptoapi (https://github.com/cstjohn810/cryptoapi)") %>%
  httr2::req_url_path_append(path_append) %>%
  httr2::req_url_query(!!!query_params) %>%
  # httr2::req_dry_run()
  httr2::req_perform() %>%
  httr2::resp_body_json()

  # resp

  if(price_only == FALSE) {
    resp

  } else if (exchange == "binance" | exchange == "binance-us") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::pull(price) %>%
      as.numeric()

  } else if (exchange == "bitstamp") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::pull(last) %>%
      as.numeric()

  } else if (exchange == "bittrex") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::pull(lastTradeRate) %>%
      as.numeric()

  } else if (exchange == "coinbase") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::pull(amount) %>%
      as.numeric()

  } else if (exchange == "coinbase-pro") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::pull(price) %>%
      as.numeric()

  } else if (exchange == "crypto.com") {
    resp$result$data$a

  } else if (exchange == "ftx" | exchange == "ftx-us") {
    resp$result$price

  } else if (exchange == "gemini") {
    resp$close %>%
      as.numeric()

  } else if (exchange == "huobi") {
    resp$tick$data[[1]]$price

  } else if (exchange == "kraken") {
    resp$result[[1]]$p[1] %>%
      as.numeric()

  } else if (exchange == "kucoin") {
    resp$data$price %>%
      as.numeric()

  } else if (exchange == "poloniex") {
    sub_list <- paste0(quote_asset, "_", base_asset)
    resp[sub_list] %>% purrr::map_dfr(magrittr::extract) %>% dplyr::pull(last) %>% as.numeric()


  } else {
    resp
  }
}
