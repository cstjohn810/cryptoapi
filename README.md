
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cryptoapi

<!-- badges: start -->
<!-- badges: end -->

The goal of cryptoapi is to be a wrapper that imports and analyzes data
from Binance, Binance US, Bitstamp, Coinbase, Coinbase Pro, Crypto.com,
FTX, FTX US, Gemini, Huobi, Kraken, and Kucoin.

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
#> [1] 48109.8
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
#> # A tibble: 100 x 4
#>    bids_price     bids_qty   asks_price     asks_qty  
#>    <chr>          <chr>      <chr>          <chr>     
#>  1 48130.96000000 0.59339000 48130.97000000 0.06312000
#>  2 48130.35000000 0.02300000 48131.34000000 0.00649000
#>  3 48120.96000000 0.11080000 48133.85000000 0.00208000
#>  4 48119.27000000 0.34999000 48135.99000000 0.08600000
#>  5 48119.26000000 0.62918000 48136.00000000 0.01948000
#>  6 48119.25000000 0.04603000 48136.01000000 0.22600000
#>  7 48119.18000000 1.66000000 48137.82000000 0.06534000
#>  8 48119.17000000 0.04892000 48137.84000000 0.01051000
#>  9 48119.14000000 0.04269000 48137.85000000 0.06506000
#> 10 48115.75000000 0.02000000 48138.10000000 0.03000000
#> # ... with 90 more rows
```
