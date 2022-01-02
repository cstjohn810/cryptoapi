
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
#> [1] 47607.81
```

Alternatively, get extra price information by toggling the price\_only
option:

``` r
public_ticker_price(exchange = "ftx", base_asset = "BTC", quote_asset = "USD", price_only = FALSE)
#> # A tibble: 1 x 20
#>   name  enabled postOnly priceIncrement sizeIncrement minProvideSize  last   bid
#>   <chr> <lgl>   <lgl>             <dbl>         <dbl>          <dbl> <dbl> <dbl>
#> 1 BTC/~ TRUE    FALSE                 1        0.0001         0.0001 47627 47626
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
#> # A tibble: 16,557 x 4
#>    bids_price bids_qty asks_price asks_qty
#>         <dbl>    <dbl>      <dbl>    <dbl>
#>  1     47620.   0.0273     47624.   0.001 
#>  2     47620.   0.0271     47624.   0.001 
#>  3     47619.   0.0336     47624.   1.63  
#>  4     47619.   0.948      47626.   1.05  
#>  5     47619.   0.0378     47626.   0.106 
#>  6     47617.   0.0636     47627.   0.0210
#>  7     47616.   0.252      47627.   0.210 
#>  8     47616.   0.293      47628.   0.149 
#>  9     47615.   1.05       47629.   0.0267
#> 10     47614.   0.042      47629.   0.279 
#> # ... with 16,547 more rows
```

View candle information (OHLC):

``` r
public_candles("gemini", time_frame = "1m") %>% 
  head(1)
#> [[1]]
#> [[1]][[1]]
#> [1] 1641084360000
#> 
#> [[1]][[2]]
#> [1] 47600
#> 
#> [[1]][[3]]
#> [1] 47648.47
#> 
#> [[1]][[4]]
#> [1] 47600
#> 
#> [[1]][[5]]
#> [1] 47646.09
#> 
#> [[1]][[6]]
#> [1] 0.04160049
```

View recent trades:

``` r
public_trades(exchange = "kraken")
#> # A tibble: 1,000 x 6
#>    price       volume            time side  type  misc 
#>    <chr>       <chr>            <dbl> <chr> <chr> <chr>
#>  1 47569.30000 0.00025000 1641080241. b     l     ""   
#>  2 47569.30000 0.01345932 1641080242. b     l     ""   
#>  3 47569.20000 0.00337596 1641080256. s     m     ""   
#>  4 47569.20000 0.01225998 1641080256. s     m     ""   
#>  5 47562.10000 0.00060000 1641080256. s     m     ""   
#>  6 47550.10000 0.00837117 1641080256. s     m     ""   
#>  7 47550.10000 0.00398643 1641080256. s     m     ""   
#>  8 47550.10000 0.00973257 1641080256. s     m     ""   
#>  9 47550.10000 0.03649990 1641080256. s     m     ""   
#> 10 47550.10000 0.01653665 1641080256. s     m     ""   
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
