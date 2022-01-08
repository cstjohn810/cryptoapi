
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
#> [1] 41955.53
```

Alternatively, get extra price information by toggling the price\_only
option:

``` r
public_ticker_price(exchange = "ftx", base_asset = "BTC", quote_asset = "USD", price_only = FALSE)
#> # A tibble: 1 x 20
#>   name  enabled postOnly priceIncrement sizeIncrement minProvideSize  last   bid
#>   <chr> <lgl>   <lgl>             <dbl>         <dbl>          <dbl> <dbl> <dbl>
#> 1 BTC/~ TRUE    FALSE                 1        0.0001         0.0001 41959 41958
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
#> # A tibble: 12,640 x 4
#>    bids_price bids_qty asks_price   asks_qty
#>         <dbl>    <dbl>      <dbl>      <dbl>
#>  1     41956.  0.218       41956. 0.00000353
#>  2     41953.  0.286       41961. 1.19      
#>  3     41951.  0.0238      41962. 0.0238    
#>  4     41950.  0.00696     41963. 0.333     
#>  5     41949.  0.0558      41965. 0.286     
#>  6     41949.  0.0524      41965. 0.333     
#>  7     41949.  0.048       41965. 0.944     
#>  8     41949.  0.169       41965. 0.238     
#>  9     41949.  0.238       41966. 0.05      
#> 10     41947.  0.118       41966. 0.0596    
#> # ... with 12,630 more rows
```

View candle information (OHLC):

``` r
public_candles("gemini", time_frame = "1m")
#> # A tibble: 1,441 x 6
#>        open_time   open   high    low  close     vol
#>            <dbl>  <dbl>  <dbl>  <dbl>  <dbl>   <dbl>
#>  1 1641603300000 41957. 41984. 41957. 41982. 0.0320 
#>  2 1641603240000 41989. 41989. 41957. 41957. 0.00127
#>  3 1641603180000 41970. 41993. 41970. 41989. 1.63   
#>  4 1641603120000 41951. 41979. 41949. 41970. 0.154  
#>  5 1641603060000 41957. 41957. 41922. 41951. 0.989  
#>  6 1641603000000 41953. 41957. 41923. 41957. 0.0464 
#>  7 1641602940000 41883. 41953. 41878. 41953. 0.306  
#>  8 1641602880000 41800. 41974. 41800  41883. 1.05   
#>  9 1641602820000 41804. 41815. 41800. 41800. 0.0122 
#> 10 1641602760000 41814  41827. 41803. 41804. 0.478  
#> # ... with 1,431 more rows
```

View recent trades:

``` r
public_trades(exchange = "kraken")
#> # A tibble: 1,000 x 6
#>     price   volume time                side  type  misc 
#>     <dbl>    <dbl> <dttm>              <chr> <chr> <chr>
#>  1 41572. 0.000957 2022-01-07 23:40:51 b     m     ""   
#>  2 41572. 0.000187 2022-01-07 23:41:03 s     l     ""   
#>  3 41572. 0.00430  2022-01-07 23:41:05 b     m     ""   
#>  4 41571. 0.0116   2022-01-07 23:41:12 b     m     ""   
#>  5 41571. 0.00921  2022-01-07 23:41:17 b     m     ""   
#>  6 41571. 0.000748 2022-01-07 23:41:18 b     l     ""   
#>  7 41571. 0.0135   2022-01-07 23:41:20 b     l     ""   
#>  8 41570. 0.000724 2022-01-07 23:41:24 s     l     ""   
#>  9 41570. 0.000837 2022-01-07 23:41:45 s     l     ""   
#> 10 41571. 0.00304  2022-01-07 23:41:55 b     m     ""   
#> # ... with 990 more rows
```

View additional asset information:

``` r
public_asset_info("gemini")
#> # A tibble: 1 x 8
#>   symbol base_currency quote_currency  tick_size quote_increment min_order_size
#>   <chr>  <chr>         <chr>               <dbl>           <dbl>          <dbl>
#> 1 BTCUSD BTC           USD            0.00000001            0.01        0.00001
#> # ... with 2 more variables: status <chr>, wrap_enabled <lgl>
```
