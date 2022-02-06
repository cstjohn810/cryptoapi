
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
#> [1] 41554.31
```

Alternatively, get extra price information by toggling the price\_only
option:

``` r
public_ticker_price(exchange = "ftx", base_asset = "BTC", quote_asset = "USD", price_only = FALSE)
#> # A tibble: 1 x 21
#>   name  enabled postOnly priceIncrement sizeIncrement minProvideSize  last   bid
#>   <chr> <lgl>   <lgl>             <dbl>         <dbl>          <dbl> <dbl> <dbl>
#> 1 BTC/~ TRUE    FALSE                 1        0.0001         0.0001 41574 41576
#> # ... with 13 more variables: ask <dbl>, price <dbl>, type <chr>,
#> #   baseCurrency <chr>, quoteCurrency <chr>, restricted <lgl>,
#> #   highLeverageFeeExempt <lgl>, largeOrderThreshold <dbl>, change1h <dbl>,
#> #   change24h <dbl>, changeBod <dbl>, quoteVolume24h <dbl>, volumeUsd24h <dbl>
```

If necessary, find the available assets for any exchange:

``` r
public_asset_list(exchange = "crypto.com")
#> # A tibble: 275 x 10
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
#> # ... with 265 more rows, and 5 more variables: margin_trading_enabled <lgl>,
#> #   margin_trading_enabled_5x <lgl>, margin_trading_enabled_10x <lgl>,
#> #   max_quantity <dbl>, min_quantity <dbl>
```

View order book for varying depths:

``` r
public_order_book(exchange = "coinbase-pro", level = 2)
#> # A tibble: 19,525 x 4
#>    bids_price bids_qty asks_price asks_qty
#>         <dbl>    <dbl>      <dbl>    <dbl>
#>  1     41584. 0.0160       41584.   0.0551
#>  2     41582. 0.000692     41584.   0.1   
#>  3     41582. 0.0141       41584.   0.289 
#>  4     41581. 0.000846     41584.   0.0917
#>  5     41581. 0.000723     41584.   0.241 
#>  6     41580. 0.0326       41585.   0.0723
#>  7     41580. 0.0484       41587.   0.06  
#>  8     41580. 0.0601       41588.   0.0241
#>  9     41576. 0.120        41588.   0.0982
#> 10     41574. 0.0298       41588.   0.602 
#> # ... with 19,515 more rows
```

View candle information (OHLC):

``` r
public_candles("gemini", time_frame = "1m")
#> # A tibble: 1,441 x 6
#>        open_time   open   high    low  close       vol
#>            <dbl>  <dbl>  <dbl>  <dbl>  <dbl>     <dbl>
#>  1 1644112140000 41587. 41587. 41575. 41575. 0.0000553
#>  2 1644112080000 41581. 41589. 41574. 41587. 0.0180   
#>  3 1644112020000 41575. 41589. 41575. 41581. 0.0169   
#>  4 1644111960000 41569. 41575. 41569. 41575. 0.148    
#>  5 1644111900000 41566. 41569. 41561. 41569. 0.00184  
#>  6 1644111840000 41558. 41566. 41549. 41566. 0.516    
#>  7 1644111780000 41549. 41558. 41548. 41558. 0.00956  
#>  8 1644111720000 41537. 41561. 41537. 41549. 0.0499   
#>  9 1644111660000 41559. 41559. 41537. 41537. 0.0483   
#> 10 1644111600000 41561. 41564. 41559. 41559. 0.00126  
#> # ... with 1,431 more rows
```

View recent trades:

``` r
public_trades(exchange = "kraken")
#> # A tibble: 1,000 x 6
#>     price   volume time                side  type  misc 
#>     <dbl>    <dbl> <dttm>              <chr> <chr> <chr>
#>  1 41468  0.005    2022-02-06 00:15:04 b     m     ""   
#>  2 41468  0.00331  2022-02-06 00:15:07 b     m     ""   
#>  3 41468. 0.000308 2022-02-06 00:15:12 s     l     ""   
#>  4 41468  0.00419  2022-02-06 00:15:17 b     m     ""   
#>  5 41468  0.0002   2022-02-06 00:15:26 b     l     ""   
#>  6 41468  0.00480  2022-02-06 00:15:27 b     m     ""   
#>  7 41468  0.00199  2022-02-06 00:15:38 b     m     ""   
#>  8 41468  0.00250  2022-02-06 00:15:52 b     l     ""   
#>  9 41468  0.0161   2022-02-06 00:15:54 b     l     ""   
#> 10 41468  0.0129   2022-02-06 00:15:55 b     l     ""   
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
window. You may optionally specify a separate portfolio if you have
multiple in a single exchange.

``` r
set_api_key(exchange = "binance", key_type = "test", portfolio = "default")
```

Get coin balance. Currently only coinbase-pro is supported. You may
optionally specify a separate portfolio if you have multiple in a single
exchange.

``` r
private_balance(exchange = "coinbase-pro", portfolio = "default")
```
