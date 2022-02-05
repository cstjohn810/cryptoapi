#' Read Celsius History File
#'
#' Convenience function to import a csv from Celsius history.
#'   API access seems difficult at this moment for individuals with Celsius but it is possible
#'   to export a transaction log manually.
#'
#' @param path
#'
#' @return
#' @export
#'
read_celsius_history <- function(path) {

  readr::read_csv(path) %>%
    dplyr::mutate(exchange = "celsius",
           `Date and time` =  lubridate::as_date(lubridate::mdy_hm(`Date and time`))) %>%
    dplyr::select(date = `Date and time`, internal_id = `Internal id`, transaction = `Transaction type`,
                  coin = `Coin type`, crypto_amount = `Coin amount`, usd_value = `USD Value`,
                  original_interest_coin = `Original Interest Coin`,
                  interest_amt_orig = `Interest Amount In Original Coin`,
                  confirmed = Confirmed, exchange)

}
