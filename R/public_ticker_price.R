#' GET current public ticker price and market data
#'
#' @param exchange Which exchange to use for price and market data. Choices are binance, binance-us, bitstamp, coinbase, coinbase-pro,
#'        crypto.com, ftx, ftx-us, gemini, huobi, kraken, and kucoin.
#' @param base_asset Base asset (default BTC)
#' @param quote_asset Quote asset (default USD)
#' @param price_only If TRUE, only give current price as a numeric vector. If false, give all market data
#' @param ... Other parameters passed to API call
#'
#' @return
#' @export
#' @importFrom magrittr `%>%`
#'
#' @examples public_ticker_price("binance")
public_ticker_price <- function(exchange = "binance", base_asset = "BTC", quote_asset = "USD", price_only = TRUE, ...) {

  exchange <- tolower(exchange)

  no_usd_exchanges <- c("binance", "crypto.com", "huobi", "kucoin")

  quote_asset <- if(exchange %in% no_usd_exchanges & quote_asset == "USD") {
    "USDT"
  } else {
    "USD"
  }

  path_append <- dplyr::case_when(
    exchange == "binance" | exchange == "binance-us" ~ "api/v3/ticker/price",
    exchange == "bitstamp" ~ paste0("ticker/", tolower(base_asset), tolower(quote_asset)),
    exchange == "coinbase" ~  paste0("prices/", base_asset, "-", quote_asset, "/spot"),
    exchange == "coinbase-pro" ~  paste0("products/", base_asset, "-", quote_asset, "/ticker"),
    exchange == "crypto.com" ~  "public/get-ticker",
    exchange == "ftx" | exchange == "ftx-us" ~ paste0("markets/", base_asset, "/", quote_asset),
    exchange == "gemini" ~ paste0("v2/ticker/", base_asset, quote_asset),
    exchange == "huobi" ~ "market/trade",
    exchange == "kraken" ~ "public/Ticker",
    exchange == "kucoin" ~ "api/v1/market/orderbook/level1",
    TRUE ~ "Unsupported exchange or invalid entry"
    )

  params <- if(exchange == "binance" | exchange == "binance-us") {
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
    httr2::req_url_query(!!!params) %>%
    # httr2::req_dry_run()
    httr2::req_perform() %>%
    httr2::resp_body_json()

 if(price_only == FALSE){
   resp

   } else if (exchange == "bitstamp") {
     resp %>%
       tibble::as_tibble() %>%
       dplyr::pull(last) %>%
       as.numeric()

     } else if (exchange == "binance" | exchange == "binance-us") {
     resp %>%
       tibble::as_tibble() %>%
       dplyr::pull(price) %>%
       as.numeric()

       } else if(exchange == "coinbase") {
         resp$data$amount %>%
           as.numeric()

         } else if(exchange == "coinbase-pro") {
           resp$price %>%
             as.numeric()

           } else if(exchange == "crypto.com") {
             resp$result$data$a

             } else if(exchange == "ftx" | exchange == "ftx-us") {
               resp$result$price

               } else if(exchange == "gemini") {
                 resp$close %>%
                   as.numeric()

                 } else if(exchange == "huobi") {
                   resp$tick$data[[1]]$price

                   } else if(exchange == "kraken") {
                     resp$result$XXBTZUSD$p[[1]] %>%
                       as.numeric()

                     } else if(exchange == "kucoin") {
                       resp$data$price %>%
                         as.numeric()

                       } else {
                         resp
                       }
  }



