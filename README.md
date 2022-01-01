
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
#> [1] 47640.2
```

Alternatively, get extra price information by toggling the price\_only
option:

``` r
public_ticker_price(exchange = "ftx", base_asset = "BTC", quote_asset = "USD", price_only = FALSE)
#> # A tibble: 1 x 20
#>   name  enabled postOnly priceIncrement sizeIncrement minProvideSize  last   bid
#>   <chr> <lgl>   <lgl>             <dbl>         <dbl>          <dbl> <dbl> <dbl>
#> 1 BTC/~ TRUE    FALSE                 1        0.0001         0.0001 47659 47660
#> # ... with 12 more variables: ask <dbl>, price <dbl>, type <chr>,
#> #   baseCurrency <chr>, quoteCurrency <chr>, restricted <lgl>,
#> #   highLeverageFeeExempt <lgl>, change1h <dbl>, change24h <dbl>,
#> #   changeBod <dbl>, quoteVolume24h <dbl>, volumeUsd24h <dbl>
```

If necessary, find the available assets for any exchange:

``` r
public_asset_list(exchange = "crypto.com")
#> # A tibble: 264 x 1
#>    instrument_name
#>    <chr>          
#>  1 RSR_USDT       
#>  2 PERP_USDT      
#>  3 MATIC_BTC      
#>  4 SHIB_USDC      
#>  5 SHIB_USDT      
#>  6 GRT_CRO        
#>  7 QI_USDT        
#>  8 HOD_USDT       
#>  9 VET_BTC        
#> 10 VET_CRO        
#> # ... with 254 more rows
```

View order book for varying depths:

``` r
public_order_book(exchange = "coinbase-pro", level = 2)
#> # A tibble: 16,364 x 6
#>    bids_price bids_qty   bids.3 asks_price asks_qty   asks.3
#>    <chr>      <chr>       <int> <chr>      <chr>       <int>
#>  1 47662.36   0.08921034      1 47665.53   0.25147058      1
#>  2 47661.92   0.03800846      1 47667.37   0.01638513      1
#>  3 47661.76   0.29306189      1 47667.38   0.05245826      1
#>  4 47661.71   0.05770904      1 47668.66   0.14884         1
#>  5 47660.75   0.03948266      1 47669.18   0.1             1
#>  6 47660.24   0.1             1 47669.41   2.10195572      1
#>  7 47659.83   0.04462104      1 47669.42   0.5170879       1
#>  8 47658.65   0.10623272      1 47669.43   2.17506722      1
#>  9 47657.52   0.003777        1 47669.45   1.97401059      1
#> 10 47657.45   0.01638513      1 47669.62   0.042           1
#> # ... with 16,354 more rows
```

View candle information (OHLC):

``` r
public_candles("gemini", time_frame = "1m") %>% 
  head(1)
#> [[1]]
#> [[1]][[1]]
#> [1] 1641061620000
#> 
#> [[1]][[2]]
#> [1] 47668.38
#> 
#> [[1]][[3]]
#> [1] 47668.38
#> 
#> [[1]][[4]]
#> [1] 47668.38
#> 
#> [[1]][[5]]
#> [1] 47668.38
#> 
#> [[1]][[6]]
#> [1] 0
```

View recent trades:

``` r
public_trades(exchange = "kraken")
#> # A tibble: 1,000 x 6
#>    price       volume            time side  type  misc 
#>    <chr>       <chr>            <dbl> <chr> <chr> <chr>
#>  1 47707.70000 0.00021325 1641058785. b     l     ""   
#>  2 47710.70000 0.00150000 1641058794. b     l     ""   
#>  3 47710.80000 0.00209596 1641058794. b     l     ""   
#>  4 47710.80000 0.00209596 1641058794. b     l     ""   
#>  5 47710.80000 0.00209596 1641058794. b     l     ""   
#>  6 47710.80000 0.00110000 1641058794. b     l     ""   
#>  7 47729.60000 0.01000000 1641058798. s     l     ""   
#>  8 47729.70000 0.00639831 1641058801. b     m     ""   
#>  9 47729.70000 0.00180000 1641058801. b     m     ""   
#> 10 47729.80000 0.00160000 1641058801. b     m     ""   
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
