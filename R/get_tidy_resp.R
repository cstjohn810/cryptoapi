#' Transform API response into tidy format
#'
#' @param exchange Which exchange to use for price and market data.
#' @param fn Which function
#' @param base_asset Base asset
#' @param quote_asset Quote asset
#' @param resp Response object
#'
#' @return
#'
get_tidy_resp <- function (exchange, fn, base_asset, quote_asset, resp) {
  # public_ticker_price ----

  if ((exchange == "binance" | exchange == "binance-us" | exchange == "coinbase-pro") & fn == "public_ticker_price") {
    resp$price %>%
      as.numeric()

  } else if (exchange == "bitstamp" & fn == "public_ticker_price") {
    resp$last %>%
      as.numeric()

  } else if (exchange == "bittrex" & fn == "public_ticker_price") {
    resp$lastTradeRate %>%
      as.numeric()

  } else if (exchange == "coinbase" & fn == "public_ticker_price") {
    resp$data$amount %>%
      as.numeric()

  } else if (exchange == "crypto.com" & fn == "public_ticker_price") {
    resp$result$data$a

  } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_ticker_price") {
    resp$result$price

  } else if (exchange == "gemini" & fn == "public_ticker_price") {
    resp$close %>%
      as.numeric()

  } else if (exchange == "huobi" & fn == "public_ticker_price") {
    resp$tick$data[[1]]$price

  } else if (exchange == "kraken" & fn == "public_ticker_price") {
    resp$result[[1]]$p[1] %>%
      as.numeric()

  } else if (exchange == "kucoin" & fn == "public_ticker_price") {
    resp$data$price %>%
      as.numeric()

  } else if (exchange == "poloniex" & fn == "public_ticker_price") {
    sub_list <- paste0(quote_asset, "_", base_asset)
    resp[sub_list] %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::pull(last) %>%
      as.numeric()

  }
  # public_ticker_price_addl ----

  else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_ticker_price_addl") {
    resp %>%
      tibble::as_tibble() %>%
      dplyr::mutate(price = as.numeric(price))

  } else if (exchange == "bitstamp" & fn == "public_ticker_price_addl") {
    resp %>%
      tibble::as_tibble() %>%
      dplyr::mutate(dplyr::across(.cols = dplyr::everything(), .fns = as.numeric))

  } else if (exchange == "bittrex" & fn == "public_ticker_price_addl") {
    resp %>%
      tibble::as_tibble() %>%
      dplyr::mutate(dplyr::across(.cols = 2:dplyr::last_col(), .fns = as.numeric))

  } else if (exchange == "coinbase" & fn == "public_ticker_price_addl") {
    resp$data %>%
      tibble::as_tibble() %>%
      dplyr::mutate(amount = as.numeric(amount))

  } else if (exchange == "coinbase-pro" & fn == "public_ticker_price_addl") {
    resp %>%
      tibble::as_tibble() %>%
      dplyr::mutate(dplyr::across(.cols = c(trade_id, price, size, bid, ask, volume), .fns = as.numeric)) %>%
      dplyr::mutate(time = lubridate::as_datetime(time))

  } else if (exchange == "crypto.com" & fn == "public_ticker_price_addl") {
    resp$result$data %>%
      tibble::as_tibble() %>%
      dplyr::select(instrument_name = i, best_bid = b, best_ask = k, last_price = a, timestamp = t, vol_24hr = v, high_24hr = h, low_24hr = l, change_24hr = c)

  } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_ticker_price_addl") {
    resp$result %>%
      purrr::compact() %>%
      tibble::as_tibble()

  } else if (exchange == "gemini" & fn == "public_ticker_price_addl") {
    resp %>%
      tibble::as_tibble()

  } else if (exchange == "huobi" & fn == "public_ticker_price_addl") {
    resp %>%
      tibble::as_tibble()

  } else if (exchange == "kraken" & fn == "public_ticker_price_addl") {
    resp$result %>%
      tibble::as_tibble()

  } else if (exchange == "kucoin" & fn == "public_ticker_price_addl") {
    resp$data %>%
      tibble::as_tibble() %>%
      dplyr::mutate(dplyr::across(.cols = dplyr::everything(), .fns = as.numeric))

  } else if (exchange == "poloniex" & fn == "public_ticker_price_addl") {
    sub_list <- paste0(quote_asset, "_", base_asset)
    resp[sub_list][[1]] %>%
      tibble::as_tibble() %>%
      dplyr::mutate(dplyr::across(.cols = dplyr::everything(), .fns = as.numeric))

  }

  # public_asset_list ----
  else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_asset_list") {
    resp$symbols %>%
      purrr::map_dfr(magrittr::extract, 1:9)

  } else if (exchange == "bitstamp" & fn == "public_asset_list")  {
    resp %>%
      purrr::map_dfr(magrittr::extract )%>%
      tidyr::separate(name, sep = "/", into = c("base_asset", "quote_asset"))

  } else if (exchange == "bittrex" & fn == "public_asset_list")  {
    resp %>%
      purrr::map_dfr(magrittr::extract, 1:7) %>%
      dplyr::mutate(createdAt = lubridate::as_datetime(createdAt))

  } else if(exchange == "coinbase" & fn == "public_asset_list") {
    resp$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(min_size = as.numeric(min_size))

  } else if(exchange == "coinbase-pro" & fn == "public_asset_list") {
    resp %>%
      purrr::map_dfr(magrittr::extract)

  } else if(exchange == "crypto.com" & fn == "public_asset_list") {
    resp$result$instruments %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(max_quantity = as.numeric(max_quantity),
                    min_quantity = as.numeric(min_quantity))

  } else if((exchange == "ftx" | exchange == "ftx-us") & fn == "public_asset_list") {
    resp$result %>%
      purrr::map_dfr(magrittr::extract)

  } else if(exchange == "gemini" & fn == "public_asset_list") {
    resp %>%
      unlist() %>%
      tibble::as_tibble()

  } else if(exchange == "huobi" & fn == "public_asset_list") {
    resp$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(dplyr::across(dplyr::contains("-time"), lubridate::hms, quiet = TRUE))

  } else if(exchange == "kraken" & fn == "public_asset_list") {
    resp$result %>%
      purrr::map_dfr(magrittr::extract)

  } else if(exchange == "kucoin" & fn == "public_asset_list") {
    resp$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(dplyr::across(baseMinSize:priceLimitRate, as.numeric))

  } else if(exchange == "poloniex" & fn == "public_asset_list") {
    resp <- resp %>%
      tibble::tibble(symbol = names(.))
    resp %>%
      tidyr::unnest_wider(data = resp, col = .) %>%
      tidyr::separate(symbol, sep = "_", into = c("base_asset", "quote_asset")) %>%
      dplyr::mutate(dplyr::across(last:low24hr, as.numeric))
  }

  # public_order_book ----
  # else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_order_book") {
  #   list(...,
  #        symbol = paste0(base_asset, quote_asset),
  #        limit = depth)
  #
  # }
  # else if (exchange == "bitstamp" & fn == "public_order_book") {
  #   list(...,
  #        group = level)
  #
  # } else if (exchange == "bittrex" & fn == "public_order_book") {
  #   list(...,
  #        depth = depth)
  #
  # } else if (exchange == "coinbase-pro" & fn == "public_order_book") {
  #   list(...,
  #        level = level)
  #
  # } else if (exchange == "crypto.com" & fn == "public_order_book") {
  #   list(...,
  #        instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)),
  #        depth = depth)
  #
  # } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_order_book") {
  #   list(...,
  #        depth = depth)
  #
  # } else if (exchange == "gemini" & fn == "public_order_book") {
  #   list(...,
  #        limit_bids = depth,
  #        limit_asks = depth)
  #
  # } else if (exchange == "huobi" & fn == "public_order_book") {
  #   list(...,
  #        symbol = paste0(tolower(base_asset), tolower(quote_asset)),
  #        type = level)
  #
  # } else if (exchange == "kraken" & fn == "public_order_book") {
  #   list(...,
  #        pair = paste0(base_asset, quote_asset),
  #        count = depth)
  #
  # } else if (exchange == "kucoin" & fn == "public_order_book") {
  #   list(...,
  #        symbol = paste0(toupper(base_asset), "-", toupper(quote_asset)))
  #
  # } else if (exchange == "poloniex" & fn == "public_order_book") {
  #   list(...,
  #        command = "returnOrderBook",
  #        currencyPair = paste0(toupper(quote_asset), "_", toupper(base_asset)),
  #        depth = depth)
  #
  # }

  # public_candles ----
  # else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_candles") {
  #   list(...,
  #        symbol = paste0(base_asset, quote_asset),
  #        interval = time_frame,
  #        start_time = start_time,
  #        end_time = end_time,
  #        limit = limit)
  #
  # } else if (exchange == "bitstamp" & fn == "public_candles") {
  #   list(...,
  #        start = start_time,
  #        end = end_time,
  #        step = time_frame,
  #        limit = limit)
  #
  # } else if (exchange == "coinbase-pro" & fn == "public_candles") {
  #   list(...,
  #        start = start_time,
  #        end = end_time,
  #        granularity = time_frame)
  #
  # } else if (exchange == "crypto.com" & fn == "public_candles") {
  #   list(...,
  #        instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)),
  #        timeframe = time_frame)
  #
  # } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_candles") {
  #   list(...,
  #        start_time = start_time,
  #        end_time = end_time,
  #        resolution = time_frame)
  #
  # } else if (exchange == "huobi" & fn == "public_candles") {
  #   list(...,
  #        symbol = paste0(tolower(base_asset), tolower(quote_asset)),
  #        period = time_frame,
  #        size = limit)
  #
  # } else if (exchange == "kraken" & fn == "public_candles") {
  #   list(...,
  #        pair = paste0(base_asset, quote_asset),
  #        interval = time_frame,
  #        since = start_time)
  #
  # } else if (exchange == "kucoin" & fn == "public_candles") {
  #   list(...,
  #        symbol = paste0(toupper(base_asset), "-", toupper(quote_asset)),
  #        startAt = start_time,
  #        endAt = end_time,
  #        type = time_frame)
  #
  # } else if (exchange == "poloniex" & fn == "public_candles") {
  #   list(...,
  #        command = "returnChartData",
  #        currencyPair = paste0(toupper(quote_asset), "_", toupper(base_asset)),
  #        start = start_time,
  #        end = end_time,
  #        period = time_frame)
  #
  # }

  # public_trades ----
  # else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_trades") {
  #   list(...,
  #        symbol = paste0(base_asset, quote_asset),
  #        limit = limit)
  #
  # } else if (exchange == "bitstamp" & fn == "public_trades") {
  #   list(...,
  #        time = time_frame)
  #
  # } else if (exchange == "coinbase-pro" & fn == "public_trades") {
  #   list(...,
  #        limit = limit)
  #
  # } else if (exchange == "crypto.com" & fn == "public_trades") {
  #   list(...,
  #        instrument_name = paste0(toupper(base_asset), "_", toupper(quote_asset)))
  #
  # } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_trades") {
  #   list(...,
  #        start_time = start_time,
  #        end_time = end_time)
  #
  # } else if (exchange == "gemini" & fn == "public_trades") {
  #   list(...,
  #        limit_trades = limit,
  #        timestamp = start_time)
  #
  # } else if (exchange == "huobi" & fn == "public_trades") {
  #   list(...,
  #        symbol = paste0(tolower(base_asset), tolower(quote_asset)),
  #        size = limit)
  #
  # } else if (exchange == "kraken" & fn == "public_trades") {
  #   list(...,
  #        pair = paste0(base_asset, quote_asset))
  #
  # } else if (exchange == "kucoin" & fn == "public_trades") {
  #   list(...,
  #        symbol = paste0(toupper(base_asset), "-", toupper(quote_asset)))
  #
  # } else if (exchange == "poloniex" & fn == "public_trades") {
  #   list(...,
  #        command = "returnTradeHistory",
  #        currencyPair = paste0(toupper(quote_asset), "_", toupper(base_asset)),
  #        start = start_time,
  #        end = end_time)
  #
  # }

  # public_asset_info ----


  # else ----
  else {
    resp
  }

}
