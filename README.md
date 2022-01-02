
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
#> [1] 47376.18
```

Alternatively, get extra price information by toggling the price\_only
option:

``` r
public_ticker_price(exchange = "ftx", base_asset = "BTC", quote_asset = "USD", price_only = FALSE)
#> # A tibble: 1 x 20
#>   name  enabled postOnly priceIncrement sizeIncrement minProvideSize  last   bid
#>   <chr> <lgl>   <lgl>             <dbl>         <dbl>          <dbl> <dbl> <dbl>
#> 1 BTC/~ TRUE    FALSE                 1        0.0001         0.0001 47386 47385
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
#> # A tibble: 16,547 x 4
#>    bids_price bids_qty asks_price asks_qty
#>         <dbl>    <dbl>      <dbl>    <dbl>
#>  1     47377.   0.387      47377.   0.117 
#>  2     47376.   0.150      47380.   0.0270
#>  3     47375.   0.0211     47382.   0.0325
#>  4     47375.   0.0503     47383.   0.0282
#>  5     47375.   0.253      47384.   0.0503
#>  6     47374.   0.0075     47384.   1.06  
#>  7     47373.   0.211      47384.   0.0245
#>  8     47373.   0.047      47385.   0.0211
#>  9     47373.   0.05       47386.   1.96  
#> 10     47371.   0.008      47386.   0.111 
#> # ... with 16,537 more rows
```

View candle information (OHLC):

``` r
public_candles("gemini", time_frame = "1m")
#> # A tibble: 1,441 x 6
#>        open_time   open   high    low  close     vol
#>            <dbl>  <dbl>  <dbl>  <dbl>  <dbl>   <dbl>
#>  1 1641092940000 47391. 47391. 47391. 47391. 0.00291
#>  2 1641092880000 47399. 47399. 47390. 47391. 0.0919 
#>  3 1641092820000 47401. 47405. 47392. 47399. 0.0312 
#>  4 1641092760000 47404. 47408. 47400. 47401. 0.0730 
#>  5 1641092700000 47403. 47408. 47391. 47404. 0.191  
#>  6 1641092640000 47383. 47425. 47383. 47403. 1.65   
#>  7 1641092580000 47403. 47405. 47383. 47383. 0.0733 
#>  8 1641092520000 47398. 47408. 47398. 47403. 0.0103 
#>  9 1641092460000 47391. 47403. 47390. 47398. 0.00203
#> 10 1641092400000 47387. 47391. 47377. 47391. 0.0129 
#> # ... with 1,431 more rows
```

View recent trades:

``` r
public_trades(exchange = "kraken")
#> # A tibble: 1,000 x 6
#>    price       volume            time side  type  misc 
#>    <chr>       <chr>            <dbl> <chr> <chr> <chr>
#>  1 47629.30000 0.00041988 1641084933. b     l     ""   
#>  2 47629.30000 0.03289815 1641084934. b     m     ""   
#>  3 47638.80000 0.00167883 1641084944. b     m     ""   
#>  4 47638.80000 0.00839418 1641084949. b     m     ""   
#>  5 47638.90000 0.00600000 1641084961. b     m     ""   
#>  6 47653.40000 0.00580572 1641084961. b     m     ""   
#>  7 47653.80000 0.00010441 1641084966. s     l     ""   
#>  8 47653.70000 0.00086559 1641084966. s     l     ""   
#>  9 47639.00000 0.00060000 1641085027. s     l     ""   
#> 10 47623.80000 0.00214000 1641085027. s     l     ""   
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
