#' GET additional asset information
#'
#' @param exchange Which exchange to use for price and market data.
#'        Choices are "bittrex", "coinbase-pro", "gemini", and "kucoin".
#' @param base_asset Base asset (default "BTC")
#' @param quote_asset Quote asset (default "USD")
#' @param dry_run If TRUE, call httr2::req_dry_run, which shows the API call without actually sending it.
#'
#' @return
#' @export
#'
#'
#' @examples
#' public_asset_info("bittrex")
#' public_asset_info("coinbase-pro")
#' public_asset_info("gemini")
#' public_asset_info("kucoin")
#'
#' @importFrom magrittr `%>%`
public_asset_info <- function(exchange = "coinbase-pro", base_asset = "BTC", quote_asset = "USD", dry_run = FALSE) {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin", "poloniex")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    quote_asset
  }

  base_url <- get_base_url(exchange)

  path_append <- get_path_append(exchange, "public_asset_info", base_asset, quote_asset)

  resp <- get_api_response(base_url, path_append, dry_run, query_params = NULL)

  if(dry_run == TRUE) {
    resp
  } else if(exchange == "bittrex") {
    tibble::tibble(result = resp) %>%
      tidyr::unnest_wider(col = result)

  } else if (exchange == "coinbase-pro") {
    resp %>% tibble::as_tibble()

  } else if (exchange == "gemini") {
    resp %>% tibble::as_tibble()

  } else if (exchange == "kucoin") {
    resp$data

  } else {
    resp
  }
}
