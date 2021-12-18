#' GET current public order book data
#'
#' @param exchange Which exchange to use for price and market data. Choices are "binance", "binance-us", "bitstamp", "coinbase-pro",
#'        "crypto.com", "ftx", "ftx-us", "gemini", "kraken", and "kucoin".
#' @param base_asset Base asset (default BTC)
#' @param quote_asset Quote asset (default USD)
#' @param ... Query parameters passed to API call
#' @param limit Optional parameter to return specified number of bids and asks.
#'        Used with binance, binance-us, crypto.com, ftx, and ftx-us.
#'        Default for binance and binance-us is 100.
#' @param group Optional parameter used for accessing different data from order book from bitstamp.
#'        Possible values are 0 (orders are not grouped at same price), 1 (orders are grouped at same price - default)
#'        or 2 (orders with their order ids are not grouped at same price).
#' @param level Optional parameter used for coinbase-pro. Levels 1 and 2 are aggregated.
#'        The size field is the sum of the size of the orders at that price, and num-orders is the count of orders at that price;
#'        size should not be multiplied by num-orders. Level 3 is non-aggregated and returns the entire order book.
#' @param depth Optional parameter used to specify number of bids and asks to return.
#'        Default for crypto.com is max of 150.
#'        Default for ftx and ftx-us is 20 with max of 100.
#'        Default for gemini is 50.
#'        Default for kraken is 100 with max of 500. May be 0 to return the full order book.
#'
#' @return
#' @export
#'
#' @examples public_order_book(exchange = "binance")
#' @examples public_order_book(exchange = "binance-us")
#' @examples public_order_book(exchange = "bitstamp")
#' @examples public_order_book(exchange = "coinbase-pro")
#' @examples public_order_book(exchange = "crypto.com")
#' @examples public_order_book(exchange = "ftx")
#' @examples public_order_book(exchange = "ftx-us")
#' @examples public_order_book(exchange = "gemini")
#' @examples public_order_book(exchange = "kraken")
#' @examples public_order_book(exchange = "kucoin")
public_order_book <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", ...,
                              limit = NULL, group = NULL, level = 1, depth = NULL) {

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
      symbol = paste0(base_asset, quote_asset),
      limit = limit
    )
  } else if(exchange == "bitstamp") {
    list(
      ...,
      group = group
    )
  } else if(exchange == "coinbase-pro") {
    list(
      ...,
      level = level
    )
  } else if(exchange == "crypto.com") {
    list(
      ...,
      instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)),
      depth = depth
    )
  } else if(exchange == "ftx" | exchange == "ftx-us") {
    list(
      ...,
      depth = depth
    )
  } else if(exchange == "gemini") {
    list(
      ...,
      limit_bids = depth,
      limit_asks = depth
    )
  } else if(exchange == "huobi") {
    list(
      ...,
      symbol = paste0(tolower(base_asset), tolower(quote_asset))
    )
  } else if(exchange == "kraken") {
    list(
      ...,
      pair = paste0(base_asset, quote_asset),
      count = depth
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

  if (exchange == "binance" | exchange == "binance-us") {
    tibble::tibble(bids = resp$bids,
                   asks = resp$asks) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::rename(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

  } else if (exchange == "bitstamp") {
    resp_len <- min(length(resp$bids), length(resp$asks))

    tibble::tibble(bids = resp$bids[1:resp_len],
                   asks = resp$asks[1:resp_len]) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::rename(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

  } else if(exchange == "coinbase-pro") {
    tibble::tibble(bids = resp$bids,
                   asks = resp$asks) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

  } else if(exchange == "crypto.com") {

    tibble::tibble(bids = resp$result$data[[1]]$bids,
                   asks = resp$result$data[[1]]$asks) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

  } else if(exchange == "ftx" | exchange == "ftx-us") {
    tibble::tibble(bids = resp$result$bids,
                   asks = resp$result$asks) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

  } else if(exchange == "gemini") {
    resp_len <- min(length(resp$bids), length(resp$asks))

    tibble::tibble(bids = resp$bids[1:resp_len],
                   asks = resp$asks[1:resp_len]) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".")

  } else if(exchange == "kraken") {
    resp <- resp$result[[1]]
    tibble::tibble(bids = resp$bids,
                   asks = resp$asks) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

  } else if(exchange == "kucoin") {
    tibble::tibble(bids = resp$data$bids,
                   asks = resp$data$asks) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::rename(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

  } else {
    resp
  }
}
