
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
#> [1] 46803.52
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
#>  1 46798.46000000 0.04181000 46798.47000000 0.26667000
#>  2 46797.29000000 0.04181000 46799.34000000 0.01068000
#>  3 46796.68000000 0.06100000 46799.35000000 0.03701000
#>  4 46796.50000000 0.21893000 46799.42000000 0.09045000
#>  5 46791.26000000 0.10679000 46799.43000000 0.09700000
#>  6 46790.40000000 0.00041000 46800.22000000 0.05460000
#>  7 46789.45000000 0.06100000 46800.62000000 0.08150000
#>  8 46789.18000000 0.11500000 46801.01000000 0.13416000
#>  9 46788.00000000 0.00041000 46801.02000000 0.30500000
#> 10 46787.89000000 0.12536000 46801.25000000 0.04016000
#> # ... with 90 more rows
```
