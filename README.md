
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

## Public API Calls

Can pull out the current ticker price of any asset from any exchange:

``` r
public_ticker_price(exchange = "binance", base_asset = "BTC", quote_asset = "USD")
#> [1] 41820.21
```

Alternatively, get extra price information by toggling the price\_only
option:

``` r
public_ticker_price(exchange = "ftx", base_asset = "BTC", quote_asset = "USD", price_only = FALSE)
#> # A tibble: 1 x 20
#>   name  enabled postOnly priceIncrement sizeIncrement minProvideSize  last   bid
#>   <chr> <lgl>   <lgl>             <dbl>         <dbl>          <dbl> <dbl> <dbl>
#> 1 BTC/~ TRUE    FALSE                 1        0.0001         0.0001 41824 41823
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
#> # A tibble: 12,774 x 4
#>    bids_price bids_qty asks_price asks_qty
#>         <dbl>    <dbl>      <dbl>    <dbl>
#>  1     41819. 0.0378       41822.  0.05   
#>  2     41819. 0.024        41822.  0.287  
#>  3     41816. 0.000115     41822.  1.20   
#>  4     41814. 0.0259       41823.  0.047  
#>  5     41814. 1.20         41823.  0.05   
#>  6     41814. 0.119        41824.  0.052  
#>  7     41814. 0.170        41824.  0.00206
#>  8     41811. 0.104        41825.  0.118  
#>  9     41811. 0.0952       41825.  0.052  
#> 10     41811. 0.000595     41825.  0.11   
#> # ... with 12,764 more rows
```

View candle information (OHLC):

``` r
public_candles("gemini", time_frame = "1m")
#> # A tibble: 1,441 x 6
#>        open_time   open   high    low  close     vol
#>            <dbl>  <dbl>  <dbl>  <dbl>  <dbl>   <dbl>
#>  1 1641611760000 41833. 41833. 41830. 41830. 0.0487 
#>  2 1641611700000 41847. 41854. 41833. 41833. 0.00286
#>  3 1641611640000 41840. 41855. 41840. 41847. 0.0761 
#>  4 1641611580000 41882. 41882. 41833. 41840. 0.0197 
#>  5 1641611520000 41891. 41904. 41882. 41882. 0.0698 
#>  6 1641611460000 41841. 41891. 41841. 41891. 0.0424 
#>  7 1641611400000 41892. 41894. 41841. 41841. 1.54   
#>  8 1641611340000 41886. 41910. 41886. 41892. 0.0187 
#>  9 1641611280000 41858. 41893. 41852. 41886. 0.0118 
#> 10 1641611220000 41847. 41866. 41847. 41858. 0.0873 
#> # ... with 1,431 more rows
```

View recent trades:

``` r
public_trades(exchange = "kraken")
#> # A tibble: 1,000 x 6
#>     price volume time                side  type  misc 
#>     <dbl>  <dbl> <dttm>              <chr> <chr> <chr>
#>  1 41971. 0.0004 2022-01-08 01:30:02 b     l     ""   
#>  2 41971. 0.0005 2022-01-08 01:30:02 b     l     ""   
#>  3 41984. 0.0515 2022-01-08 01:30:02 b     l     ""   
#>  4 41995. 0.0385 2022-01-08 01:30:03 b     l     ""   
#>  5 42009. 0.136  2022-01-08 01:30:03 b     l     ""   
#>  6 42009. 0.293  2022-01-08 01:30:03 b     l     ""   
#>  7 42013. 0.162  2022-01-08 01:30:03 b     l     ""   
#>  8 42022. 0.086  2022-01-08 01:30:03 b     l     ""   
#>  9 42026. 0.113  2022-01-08 01:30:03 b     l     ""   
#> 10 41997. 0.150  2022-01-08 01:30:03 b     l     ""   
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

## Private API Calls (Keys Required)

Set API Keys as environment variables: In normal usage, do not set the
key value in the initial function call. Leave it NULL and input the key
into the [askpass](https://rdrr.io/cran/askpass/man/askpass.html) popup
window.

``` r
set_api_key("binance", "test", key = "1234")
```
