
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cryptoapi

<!-- badges: start -->
<!-- badges: end -->

The goal of cryptoapi is to be a wrapper that imports and analyzes data
from Binance, Binance US, Bitstamp, Coinbase, Coinbase Pro, Crypto.com,
FTX, FTX US, Gemini, Huobi, Kraken, and Kucoin.

## Installation

You can install the development version of cryptoapi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("cstjohn810/cryptoapi")
```

## Example

This is a basic example:

``` r
library(cryptoapi)
library(magrittr)
public_ticker_price()
#> [1] 46012.48
```

``` r
public_asset_list(exchange = "binance")
#> # A tibble: 1,846 x 1
#>    symbol 
#>    <chr>  
#>  1 ETHBTC 
#>  2 LTCBTC 
#>  3 BNBBTC 
#>  4 NEOBTC 
#>  5 QTUMETH
#>  6 EOSETH 
#>  7 SNTETH 
#>  8 BNTETH 
#>  9 BCCBTC 
#> 10 GASBTC 
#> # ... with 1,836 more rows
```

``` r
public_order_book()
#> # A tibble: 1 x 5
#>   symbol  bidPrice       bidQty     askPrice       askQty    
#>   <chr>   <chr>          <chr>      <chr>          <chr>     
#> 1 BTCUSDT 46010.85000000 0.10618000 46010.86000000 0.03208000
```
