
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

This is a basic example:

``` r
library(cryptoapi)
library(magrittr)
public_ticker_price()
#> [1] 47189.03
```

``` r
public_asset_list(exchange = "binance")
#> # A tibble: 1,869 x 1
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
#> # ... with 1,859 more rows
```

``` r
public_order_book()
#> # A tibble: 100 x 4
#>    bids_price     bids_qty   asks_price     asks_qty  
#>    <chr>          <chr>      <chr>          <chr>     
#>  1 47192.44000000 1.02284000 47192.45000000 0.50542000
#>  2 47190.75000000 0.05297000 47192.80000000 0.00216000
#>  3 47189.41000000 0.11654000 47192.81000000 0.03000000
#>  4 47189.04000000 0.07291000 47193.90000000 0.01100000
#>  5 47189.03000000 0.38001000 47195.28000000 0.05297000
#>  6 47189.02000000 0.44093000 47196.13000000 0.00532000
#>  7 47189.01000000 0.19394000 47197.55000000 0.30356000
#>  8 47187.11000000 0.06924000 47198.37000000 0.16790000
#>  9 47187.10000000 0.07385000 47198.38000000 0.02119000
#> 10 47183.46000000 0.08264000 47198.45000000 0.34999000
#> # ... with 90 more rows
```
