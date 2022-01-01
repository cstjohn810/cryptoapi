#' GET current public order book data
#'
#' @param exchange Which exchange to use for price and market data. Choices are "binance", "binance-us", "bitstamp", "bittrex", "coinbase-pro",
#'        "crypto.com", "ftx", "ftx-us", "gemini", "huobi", "kraken", "kucoin", and "poloniex".
#' @param base_asset Base asset (default BTC)
#' @param quote_asset Quote asset (default USD)
#' @param dry_run If TRUE, call httr2::req_dry_run, which shows the API call without actually sending it.
#' @param ... Query parameters passed to API call
#' @param level Parameter used for varying aggregations of order book.
#'        \itemize{
#'          \item Optional for "coinbase-pro"
#'            \itemize{
#'              \item Level 1 (Default) - The best bid, ask and auction info
#'              \item Level 2 - Full order book (aggregated) and auction info
#'              \item Level 3 - Full order book (non aggregated) and auction info.
#'                    Abuse of Level 3 via polling will cause your access to be limited or blocked.
#'              \item The size field is the sum of the size of the orders at that price, and num-orders is the count of orders at that price;
#'                    size should not be multiplied by num-orders.
#'            }
#'          \item Optional for "bitstamp"
#'            \itemize{
#'              \item 0 (orders are not grouped at same price)
#'              \item 1 (orders are grouped at same price - default)
#'              \item 2 (orders with their order ids are not grouped at same price).
#'            }
#'          \item Required for "huobi"
#'            \itemize{
#'              \item step0 	No market depth aggregation. When type is set to "step0", the default value of "depth" is 150 instead of 20.
#'              \item step1 	Aggregation level = precision*10
#'              \item step2 	Aggregation level = precision*100
#'              \item step3 	Aggregation level = precision*1000
#'              \item step4 	Aggregation level = precision*10000
#'              \item step5 	Aggregation level = precision*100000
#'            }
#'        }
#' @param depth Optional parameter used to specify number of bids and asks to return.
#'        \itemize{
#'          \item Default for "binance" and "binance-us" is 100. Valid limits of 5, 10, 20, 50, 100, 500, 1000, 5000.
#'          \item Default for "bittrex" is 25. Allowed values are 1, 25, 500.
#'          \item Default for "crypto.com" is max of 150.
#'          \item Default for "ftx" and "ftx-us" is 20 with max of 100.
#'          \item Default for "gemini" is 50. May be 0 to return the full order book.
#'          \item Default for "huobi" is 20, unless type is set to "step0". Valid limits of 5, 10, 20.
#'          \item Default for "kraken" is 100 with max of 500.
#'          \item Default for "poloniex" is 50 with max of 100.
#'        }
#'
#' @return
#' @export
#'
#' @examples public_order_book(exchange = "binance")
#' public_order_book(exchange = "binance-us")
#' public_order_book(exchange = "bitstamp")
#' public_order_book(exchange = "bittrex")
#' public_order_book(exchange = "coinbase-pro")
#' public_order_book(exchange = "crypto.com")
#' public_order_book(exchange = "ftx")
#' public_order_book(exchange = "ftx-us")
#' public_order_book(exchange = "gemini")
#' public_order_book(exchange = "huobi", level = "step0")
#' public_order_book(exchange = "kraken")
#' public_order_book(exchange = "kucoin")
#' public_order_book(exchange = "poloniex")
public_order_book <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", dry_run = FALSE, ...,
                              level = NULL, depth = NULL) {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin", "poloniex")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    quote_asset
  }

  base_url <- get_base_url(exchange)

  path_append <- get_path_append(exchange, "public_order_book", base_asset, quote_asset)

  query_params <- get_query_params(exchange, "public_order_book", base_asset, quote_asset, ..., level = level, depth = depth)

  resp <- get_api_response(base_url, path_append, query_params, dry_run)

  if(dry_run == TRUE) {
    resp
  } else if (exchange == "binance" | exchange == "binance-us") {
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

  } else if (exchange == "bittrex") {

    tibble::tibble(bids = resp$bid,
                   asks = resp$ask) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::select(bids_price = bids.rate, bids_qty = bids.quantity, asks_price = asks.rate, asks_qty = asks.quantity)

  } else if(exchange == "coinbase-pro") {
    resp_len <- min(length(resp$bids), length(resp$asks))

    tibble::tibble(bids = resp$bids[1:resp_len],
                   asks = resp$asks[1:resp_len]) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::rename(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

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

  } else if(exchange == "huobi") {

    tibble::tibble(bids = resp$tick$bids,
                   asks = resp$tick$asks) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

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

  } else if(exchange == "poloniex") {
    tibble::tibble(bids = resp$bids,
                   asks = resp$asks) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::rename(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

  } else {
    resp
  }
}
