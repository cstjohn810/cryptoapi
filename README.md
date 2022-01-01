
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cryptoapi

<!-- badges: start -->
<!-- badges: end -->

The goal of cryptoapi is to be a wrapper that imports and analyzes data
from Binance, Binance US, Bitstamp, Bittrex, Coinbase, Coinbase Pro,
Crypto.com, FTX, FTX US, Gemini, Huobi, Kraken, Kucoin, and Poloniex.

Use at your own risk.

## Installation

You can install the development version of cryptoapi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cstjohn810/cryptoapi")
```

## Example

``` r
library(cryptoapi)
library(magrittr)
```

Can pull out the current ticker price of any asset from any exchange:

``` r
public_ticker_price(exchange = "binance", base_asset = "BTC", quote_asset = "USD")
#> [1] 47329.16
```

Alternatively, get extra price information by toggling the price\_only
option:

``` r
public_ticker_price(exchange = "ftx", base_asset = "BTC", quote_asset = "USD", price_only = FALSE)
#> # A tibble: 1 x 20
#>   name  enabled postOnly priceIncrement sizeIncrement minProvideSize  last   bid
#>   <chr> <lgl>   <lgl>             <dbl>         <dbl>          <dbl> <dbl> <dbl>
#> 1 BTC/~ TRUE    FALSE                 1        0.0001         0.0001 47334 47340
#> # ... with 12 more variables: ask <dbl>, price <dbl>, type <chr>,
#> #   baseCurrency <chr>, quoteCurrency <chr>, restricted <lgl>,
#> #   highLeverageFeeExempt <lgl>, change1h <dbl>, change24h <dbl>,
#> #   changeBod <dbl>, quoteVolume24h <dbl>, volumeUsd24h <dbl>
```

If necessary, find the available assets for any exchange:

``` r
public_asset_list(exchange = "crypto.com")
#> # A tibble: 264 x 10
#>    instrument_name quote_currency base_currency price_decimals quantity_decimals
#>    <chr>           <chr>          <chr>                  <int>             <int>
#>  1 RSR_USDT        USDT           RSR                        5                 1
#>  2 PERP_USDT       USDT           PERP                       3                 3
#>  3 MATIC_BTC       BTC            MATIC                      9                 0
#>  4 SHIB_USDC       USDC           SHIB                       9                 0
#>  5 SHIB_USDT       USDT           SHIB                       9                 0
#>  6 GRT_CRO         CRO            GRT                        3                 2
#>  7 QI_USDT         USDT           QI                         5                 1
#>  8 HOD_USDT        USDT           HOD                        6                 0
#>  9 VET_BTC         BTC            VET                       10                 0
#> 10 VET_CRO         CRO            VET                        4                 0
#> # ... with 254 more rows, and 5 more variables: margin_trading_enabled <lgl>,
#> #   margin_trading_enabled_5x <lgl>, margin_trading_enabled_10x <lgl>,
#> #   max_quantity <dbl>, min_quantity <dbl>
```

View order book for varying depths:

``` r
public_order_book(exchange = "coinbase-pro", level = 2)
#> # A tibble: 16,403 x 6
#>    bids_price bids_qty   bids.3 asks_price asks_qty   asks.3
#>    <chr>      <chr>       <int> <chr>      <chr>       <int>
#>  1 47348.68   0.03729036      1 47350.53   1.05612478      1
#>  2 47346.75   0.04027071      1 47351.17   0.03553524      1
#>  3 47346.14   0.002           2 47351.7    1.8811924       1
#>  4 47345.13   0.001           1 47352.85   0.25354351      1
#>  5 47343.94   0.03039421      1 47353.54   0.03039421      1
#>  6 47343.93   0.21134555      1 47353.55   0.09281369      1
#>  7 47343.09   0.05            1 47353.56   0.04735323      1
#>  8 47343.08   1.73508037      1 47354.9    0.09220841      1
#>  9 47343.07   0.05465347      1 47355.58   0.09412797      1
#> 10 47342.57   0.149822        1 47355.68   0.21127668      1
#> # ... with 16,393 more rows
```

View candle information (OHLC):

``` r
public_candles("gemini", time_frame = "1m") %>% 
  head(1)
#> [[1]]
#> [[1]][[1]]
#> [1] 1641068400000
#> 
#> [[1]][[2]]
#> [1] 47347.46
#> 
#> [[1]][[3]]
#> [1] 47347.46
#> 
#> [[1]][[4]]
#> [1] 47345.36
#> 
#> [[1]][[5]]
#> [1] 47345.36
#> 
#> [[1]][[6]]
#> [1] 0.00125068
```

View recent trades:

``` r
public_trades(exchange = "kraken")
#> # A tibble: 1,000 x 6
#>    price       volume            time side  type  misc 
#>    <chr>       <chr>            <dbl> <chr> <chr> <chr>
#>  1 47498.20000 0.00010000 1641062115. s     m     ""   
#>  2 47507.50000 0.00015000 1641062124. s     m     ""   
#>  3 47507.60000 0.00090472 1641062125. b     m     ""   
#>  4 47507.60000 0.00100000 1641062135. b     m     ""   
#>  5 47507.50000 0.00210493 1641062141. s     l     ""   
#>  6 47494.00000 0.02287387 1641062141. s     l     ""   
#>  7 47494.00000 0.00631796 1641062141. s     l     ""   
#>  8 47494.00000 0.01052643 1641062142. s     l     ""   
#>  9 47494.00000 0.36028174 1641062148. s     l     ""   
#> 10 47480.70000 0.00016434 1641062148. s     l     ""   
#> # ... with 990 more rows
```

View additional asset information:

``` r
public_asset_info("gemini")
#> # A tibble: 1 x 8
#>   symbol base_currency quote_currency  tick_size quote_increment min_order_size
#>   <chr>  <chr>         <chr>               <dbl>           <dbl> <chr>         
#> 1 BTCUSD BTC           USD            0.00000001            0.01 0.00001       
#> # ... with 2 more variables: status <chr>, wrap_enabled <lgl>
```
