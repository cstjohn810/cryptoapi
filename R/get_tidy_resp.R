#' Transform API response into tidy format
#'
#' @param exchange Which exchange to use for price and market data.
#' @param fn Which function
#' @param base_asset Base asset
#' @param quote_asset Quote asset
#' @param resp Response object
#' @param level Optional parameter from public_order_book
#'
#' @return
#'
get_tidy_resp <- function (exchange, fn, base_asset, quote_asset, resp, level = NULL) {
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
      purrr::map_dfr(magrittr::extract) %>%
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
  else if ((exchange == "binance" | exchange == "binance-us" | exchange == "poloniex") & fn == "public_order_book") {
    tibble::tibble(bids = resp$bids, asks = resp$asks) %>%
      tidyr::unnest_wider(col = bids, names_sep = ".") %>%
      tidyr::unnest_wider(col = asks, names_sep = ".") %>%
      dplyr::rename(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))

    } else if (exchange == "bitstamp" & fn == "public_order_book") {

      resp_len <- min(length(resp$bids), length(resp$asks))

      resp <- tibble::tibble(timestamp = as.numeric(resp$timestamp), bids = resp$bids[1:resp_len], asks = resp$asks[1:resp_len]) %>%
        tidyr::unnest_wider(col = bids, names_sep = ".") %>%
        tidyr::unnest_wider(col = asks, names_sep = ".")

      if (length(level) == 0) {
         resp <- resp %>%
          dplyr::rename(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)
      } else if (level == 1 | level == 3) {
        resp <- resp %>%
          dplyr::rename(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)
      } else if (level == 2) {
        resp <- resp %>%
          dplyr::rename(bids_price = bids.1, bids_qty = bids.2, bid_id = bids.3, asks_price = asks.1, asks_qty = asks.2, ask_id = asks.3)
      }
      resp %>%
        dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))

    } else if (exchange == "bittrex" & fn == "public_order_book") {

      tibble::tibble(bids = resp$bid, asks = resp$ask) %>%
        tidyr::unnest_wider(col = bids, names_sep = ".") %>%
        tidyr::unnest_wider(col = asks, names_sep = ".") %>%
        dplyr::select(bids_price = bids.rate, bids_qty = bids.quantity, asks_price = asks.rate, asks_qty = asks.quantity) %>%
        dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))

    } else if (exchange == "coinbase-pro" & fn == "public_order_book") {

      resp_len <- min(length(resp$bids), length(resp$asks))

      resp <- tibble::tibble(bids = resp$bids[1:resp_len], asks = resp$asks[1:resp_len]) %>%
        tidyr::unnest_wider(col = bids, names_sep = ".") %>%
        tidyr::unnest_wider(col = asks, names_sep = ".")

      if (length(level) == 0) {
        resp %>%
          dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2) %>%
          dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))
      } else if (level == 1 | level == 2) {
        resp %>%
          dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2) %>%
          dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))
      } else if (level == 3) {
        resp %>%
          dplyr::rename(bids_price = bids.1, bids_qty = bids.2, bid_id = bids.3, asks_price = asks.1, asks_qty = asks.2, ask_id = asks.3) %>%
          dplyr::mutate(dplyr::across(.cols = c(bids_price, bids_qty, asks_price, asks_qty), as.numeric))
      }


    } else if(exchange == "crypto.com" & fn == "public_order_book") {

      tibble::tibble(bids = resp$result$data[[1]]$bids, asks = resp$result$data[[1]]$asks) %>%
        tidyr::unnest_wider(col = bids, names_sep = ".") %>%
        tidyr::unnest_wider(col = asks, names_sep = ".") %>%
        dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

    } else if((exchange == "ftx" | exchange == "ftx-us") & fn == "public_order_book") {
      tibble::tibble(bids = resp$result$bids, asks = resp$result$asks) %>%
        tidyr::unnest_wider(col = bids, names_sep = ".") %>%
        tidyr::unnest_wider(col = asks, names_sep = ".") %>%
        dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

    } else if(exchange == "gemini" & fn == "public_order_book") {
      resp_len <- min(length(resp$bids), length(resp$asks))

      tibble::tibble(bids = resp$bids[1:resp_len], asks = resp$asks[1:resp_len]) %>%
        tidyr::unnest_wider(col = bids, names_sep = ".") %>%
        tidyr::unnest_wider(col = asks, names_sep = ".") %>%
        dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))

    } else if(exchange == "huobi" & fn == "public_order_book") {

      tibble::tibble(timestamp = resp$ts, bids = resp$tick$bids, asks = resp$tick$asks) %>%
        tidyr::unnest_wider(col = bids, names_sep = ".") %>%
        tidyr::unnest_wider(col = asks, names_sep = ".") %>%
        dplyr::select(timestamp, bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2)

    } else if(exchange == "kraken" & fn == "public_order_book") {
      resp <- resp$result[[1]]
      tibble::tibble(bids = resp$bids, asks = resp$asks) %>%
        tidyr::unnest_wider(col = bids, names_sep = ".") %>%
        tidyr::unnest_wider(col = asks, names_sep = ".") %>%
        dplyr::select(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2) %>%
        dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))

    } else if(exchange == "kucoin" & fn == "public_order_book") {
      tibble::tibble(bids = resp$data$bids, asks = resp$data$asks) %>%
        tidyr::unnest_wider(col = bids, names_sep = ".") %>%
        tidyr::unnest_wider(col = asks, names_sep = ".") %>%
        dplyr::rename(bids_price = bids.1, bids_qty = bids.2, asks_price = asks.1, asks_qty = asks.2) %>%
        dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))

    }

  # public_candles ----
  else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_candles") {
    nm1 <- c("open_time", "open", "high", "low", "close", "vol", "close_time", "quote_asset_vol", "num_trades", "buy_vol", "quote_vol", "ignore")

    resp <- resp %>%
      tibble::tibble(symbol = names(.))
    resp %>%
      tidyr::unnest_wider(data = resp, col = ., names_repair = ~nm1) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric)) %>%
      suppressMessages

  } else if (exchange == "bitstamp" & fn == "public_candles") {
    resp$data$ohlc %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))

  } else if (exchange == "bittrex" & fn == "public_candles") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(startsAt = lubridate::as_datetime(startsAt)) %>%
      dplyr::mutate(dplyr::across(open:quoteVolume, as.numeric))

  } else if (exchange == "coinbase-pro" & fn == "public_candles") {
    nm1 <- c("open_time", "low", "high", "open", "close", "vol")

    resp <- resp %>%
      tibble::tibble(symbol = names(.))
    resp %>%
      tidyr::unnest_wider(data = resp, col = ., names_repair = ~nm1) %>%
      suppressMessages

  } else if (exchange == "crypto.com" & fn == "public_candles") {
    resp$result$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::select(timestamp = t, open = o, high = h, low = l, close = c, vol = v)

  } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_candles") {
    resp$result %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(startTime = lubridate::as_datetime(startTime))

  } else if (exchange == "gemini" & fn == "public_candles") {
    nm1 <- c("open_time", "open", "high", "low", "close", "vol")

    resp <- resp %>%
      tibble::tibble(symbol = names(.))
    resp %>%
      tidyr::unnest_wider(data = resp, col = ., names_repair = ~nm1) %>%
      suppressMessages

  } else if (exchange == "huobi" & fn == "public_candles") {
    resp$data %>%
      purrr::map_dfr(magrittr::extract)

  } else if (exchange == "kraken" & fn == "public_candles") {
    nm1 <- c("open_time", "open", "high", "low", "close", "vwap", "vol", "count")

    resp <- resp$result[[1]] %>%
      tibble::tibble(symbol = names(.))
    resp %>%
      tidyr::unnest_wider(data = resp, col = ., names_repair = ~nm1) %>%
      dplyr::mutate(dplyr::across(open:vol, as.numeric)) %>%
      suppressMessages


  } else if (exchange == "kucoin" & fn == "public_candles") {
    nm1 <- c("open_time", "open", "close", "high", "low", "vol", "turnover")

    resp <- resp$data %>%
      tibble::tibble(symbol = names(.))
    resp %>%
      tidyr::unnest_wider(data = resp, col = ., names_repair = ~nm1) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric)) %>%
      suppressMessages

  } else if (exchange == "poloniex" & fn == "public_candles") {
    resp %>%
      purrr::map_dfr(magrittr::extract)

  }

  # public_trades ----
    else if ((exchange == "binance" | exchange == "binance-us") & fn == "public_trades") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(dplyr::across(price:quoteQty, as.numeric))

  } else if (exchange == "bitstamp" & fn == "public_trades") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(type = ifelse(type == "0", "buy", "sell")) %>%
      dplyr::mutate(dplyr::across(c(date:amount, price), as.numeric)) %>%
      dplyr::mutate(date = lubridate::as_datetime(date))

  } else if (exchange == "bittrex" & fn == "public_trades") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(dplyr::across(quantity:rate, as.numeric)) %>%
      dplyr::mutate(executedAt = lubridate::as_datetime(executedAt))

  } else if (exchange == "coinbase-pro" & fn == "public_trades") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(dplyr::across(price:size, as.numeric)) %>%
      dplyr::mutate(time = lubridate::as_datetime(time))

  } else if (exchange == "crypto.com" & fn == "public_trades") {
    resp$result$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::rename("trade_price" = "p", "trade_qty" = "q", "side" = "s", "trade_id" = "d", "timestamp" = "t", "instrument" = "i") %>%
      dplyr::mutate(dplyr::across(c(dataTime, timestamp), ~.x/1000)) %>%
      dplyr::mutate(dplyr::across(c(dataTime, timestamp), lubridate::as_datetime))

  } else if ((exchange == "ftx" | exchange == "ftx-us") & fn == "public_trades") {
    resp$result %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(time = lubridate::as_datetime(time))

  } else if (exchange == "gemini" & fn == "public_trades") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(dplyr::across(price:amount, as.numeric)) %>%
      dplyr::mutate(timestamp = lubridate::as_datetime(timestamp))

  } else if (exchange == "huobi" & fn == "public_trades") {
    resp$data[[1]]$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(ts = ts/1000) %>%
      dplyr::mutate(ts = lubridate::as_datetime(ts))

  } else if (exchange == "kraken" & fn == "public_trades") {
    tibble::tibble(result = resp$result[[1]]) %>%
      tidyr::unnest_wider(col = result, names_sep = ".") %>%
      dplyr::rename("price" = "result.1", "volume" = "result.2", "time" = "result.3", "side" = "result.4", "type" = "result.5", "misc" = "result.6") %>%
      dplyr::mutate(dplyr::across(price:volume, as.numeric)) %>%
      dplyr::mutate(time = lubridate::as_datetime(time))

  } else if (exchange == "kucoin" & fn == "public_trades") {
    resp$data %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(dplyr::across(sequence:size, as.numeric)) %>%
      dplyr::mutate(time = time/1e9) %>%
      dplyr::mutate(time = lubridate::as_datetime(time))

  } else if (exchange == "poloniex" & fn == "public_trades") {
    resp %>%
      purrr::map_dfr(magrittr::extract) %>%
      dplyr::mutate(dplyr::across(rate:total, as.numeric)) %>%
      dplyr::mutate(date = lubridate::as_datetime(date))

  }

  # public_asset_info ----
    else if(exchange == "bittrex") {
    tibble::tibble(result = resp) %>%
      tidyr::unnest_wider(col = result) %>%
        dplyr::mutate(dplyr::across(c(high:quoteVolume, percentChange), as.numeric)) %>%
        dplyr::mutate(updatedAt = lubridate::as_datetime(updatedAt))

  } else if (exchange == "coinbase-pro") {
    resp %>%
      tibble::as_tibble() %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric))

  } else if (exchange == "gemini") {
    resp %>%
      tibble::as_tibble() %>%
      dplyr::mutate(min_order_size = as.numeric(min_order_size))

  } else if (exchange == "kucoin") {
    resp$data
  }
  # else ----
  else {
    resp
  }

}
