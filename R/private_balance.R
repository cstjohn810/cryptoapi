#' Get current account balances
#' Requires API key access
#'
#' @param exchange Which exchange to use. Supported value is "coinbase-pro".
#' @param portfolio Optional value if you have multiple portfolios with separate API keys in an exchange.
#'                  This must match the set API key value in the system environment.
#'                  Use \code{\link{Sys.getenv}} to check what variables are saved if you are uncertain.
#' @param dry_run If TRUE, call httr2::req_dry_run, which shows the API call without actually sending it.
#'                In this case, there may be some discrepancy since the actual call will use httr to send, not httr2.
#'
#' @return
#' @export
#'
private_balance <- function(exchange, portfolio = NULL, dry_run = FALSE) {
  exchange <- tolower(exchange)

  base_url <- get_base_url(exchange)

  path_append <- get_path_append(exchange, "private_balance")

  req_headers <- get_req_headers(exchange, portfolio, "private_balance")

  req_url <- paste0(base_url, "/", path_append, "/")

  resp <- httr::content(httr::GET(req_url, httr::add_headers(req_headers)))

  httr2_req <- httr2::request(base_url) %>%
    httr2::req_user_agent("cryptoapi (https://github.com/cstjohn810/cryptoapi)") %>%
    httr2::req_url_path_append(path_append) %>%
    httr2::req_headers(!!!req_headers) %>%
    httr2::req_dry_run()

  if(dry_run == TRUE) {
    httr2_req
  } else {
    get_tidy_resp(exchange, "private_balance", resp = resp)
  }
}
