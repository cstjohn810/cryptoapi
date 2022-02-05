#' Set API Key as R Environment Variable
#'
#' @param exchange Which exchange to use for price and market data. Choices are "binance", "binance-us", "bitstamp", "bittrex", "coinbase",
#'        "coinbase-pro", "crypto.com", "ftx", "ftx-us", "gemini", "huobi", "kraken", "kucoin", and "poloniex".
#' @param key_type Key type: Either "API", "SECRET", or "PASSPHRASE".
#' @param key Leave NULL and input in the askpass popup.
#'
#' @return
#' @export
#'
set_api_key <- function(exchange, key_type, key = NULL) {

  exchange <- toupper(exchange)
  key_type <- toupper(key_type)

  if (get_base_url(tolower(exchange)) == "Unsupported exchange or invalid entry") {
    stop("Unsupported exchange or invalid entry")
  }

  if (!(key_type %in% c("TEST", "API", "SECRET", "PASSPHRASE"))) {
    stop("Unsupported key type (API, SECRET, PASSPHRASE)")
  }

  if (is.null(key)) {
    key <- askpass::askpass(paste("Please enter your", key_type, "key"))
  }

  args <- setNames(key, paste(exchange, key_type, sep = "_"))

  call <- rlang::expr(Sys.setenv(!!!args))

  eval(call) %>%
    suppressMessages
}
