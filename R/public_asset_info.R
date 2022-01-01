#' GET additional asset information
#'
#' @param exchange Which exchange to use for price and market data.
#'        Choices are "bittrex", "coinbase-pro", "gemini", and "kucoin".
#' @param base_asset Base asset (default "BTC")
#' @param quote_asset Quote asset (default "USD")
#'
#' @return
#' @export
#'
#' @examples
#' public_asset_info("bittrex")
#' public_asset_info("coinbase-pro")
#' public_asset_info("gemini")
#' public_asset_info("kucoin")
public_asset_info <- function(exchange = "coinbase-pro", base_asset = "BTC", quote_asset = "USD") {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin", "poloniex")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    quote_asset
  }

  base_url <- get_base_url(exchange)

  path_append <- get_path_append(exchange, "public_asset_info", base_asset, quote_asset)

  resp <- httr2::request(base_url) %>%
    httr2::req_user_agent("cryptoapi (https://github.com/cstjohn810/cryptoapi)") %>%
    httr2::req_url_path_append(path_append) %>%
    # httr2::req_dry_run()
    httr2::req_perform() %>%
    httr2::resp_body_json()

  if(exchange == "bittrex") {
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
