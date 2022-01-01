#' GET asset list for each exchange
#'
#' @param exchange Which exchange to use for list and market data. Choices are "binance", "binance-us", "bitstamp", "bittrex", "coinbase",
#'        "coinbase-pro", "crypto.com", "ftx", "ftx-us", "gemini", "huobi", "kraken", "kucoin", and "poloniex".
#' @param dry_run If TRUE, call httr2::req_dry_run, which shows the API call without actually sending it.
#' @param ... Query parameters passed to API call
#'
#' @return
#' @export
#'
#' @examples public_asset_list("binance")
#' public_asset_list("binance-us")
#' public_asset_list("bitstamp")
#' public_asset_list("bittrex")
#' public_asset_list("coinbase")
#' public_asset_list("coinbase-pro")
#' public_asset_list("crypto.com")
#' public_asset_list("ftx")
#' public_asset_list("ftx-us")
#' public_asset_list("gemini")
#' public_asset_list("huobi")
#' public_asset_list("kraken")
#' public_asset_list("kucoin")
#' public_asset_list("poloniex")
public_asset_list <- function(exchange, dry_run = FALSE, ...) {

  exchange <- tolower(exchange)

  base_url <- get_base_url(exchange)

  path_append <- get_path_append(exchange, "public_asset_list")

  query_params <- get_query_params(exchange, "public_asset_list")

  resp <- get_api_response(base_url, path_append, query_params, dry_run)

  if (exchange == "binance" | exchange == "binance-us") {
    resp$symbols %>%
      purrr::map_dfr(magrittr::extract, "symbol")

  } else if (exchange == "bitstamp")  {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(url_symbol)

  } else if (exchange == "bittrex")  {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(symbol)

  } else if(exchange == "coinbase") {
    resp$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(id)

  } else if(exchange == "coinbase-pro") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(id)

  } else if(exchange == "crypto.com") {
    resp$result$instruments %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(instrument_name)

  } else if(exchange == "ftx" | exchange == "ftx-us") {
    resp$result %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(name)

  } else if(exchange == "gemini") {
    resp %>%
      unlist() %>%
      tibble::as_tibble()

  } else if(exchange == "huobi") {
    resp$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(symbol)

  } else if(exchange == "kraken") {
    resp$result %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(altname)

  } else if(exchange == "kucoin") {
    resp$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(symbol)

  } else if(exchange == "poloniex") {
    resp %>%
      names()

  } else {
    resp
  }
}
