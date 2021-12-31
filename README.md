
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
```

Can pull out the current ticker price of any asset from any exchange:

``` r
public_ticker_price(exchange = "binance", base_asset = "BTC", quote_asset = "USD")
#> [1] 46450.05
```

Alternatively, get extra price information by toggling the price\_only
option:

``` r
public_ticker_price(exchange = "ftx", base_asset = "BTC", quote_asset = "USD", price_only = FALSE)
#> $success
#> [1] TRUE
#> 
#> $result
#> $result$name
#> [1] "BTC/USD"
#> 
#> $result$enabled
#> [1] TRUE
#> 
#> $result$postOnly
#> [1] FALSE
#> 
#> $result$priceIncrement
#> [1] 1
#> 
#> $result$sizeIncrement
#> [1] 0.0001
#> 
#> $result$minProvideSize
#> [1] 0.0001
#> 
#> $result$last
#> [1] 46460
#> 
#> $result$bid
#> [1] 46450
#> 
#> $result$ask
#> [1] 46452
#> 
#> $result$price
#> [1] 46452
#> 
#> $result$type
#> [1] "spot"
#> 
#> $result$baseCurrency
#> [1] "BTC"
#> 
#> $result$quoteCurrency
#> [1] "USD"
#> 
#> $result$underlying
#> NULL
#> 
#> $result$restricted
#> [1] FALSE
#> 
#> $result$highLeverageFeeExempt
#> [1] TRUE
#> 
#> $result$change1h
#> [1] -0.001032258
#> 
#> $result$change24h
#> [1] -0.01626429
#> 
#> $result$changeBod
#> [1] -0.01613928
#> 
#> $result$quoteVolume24h
#> [1] 540317520
#> 
#> $result$volumeUsd24h
#> [1] 540317520
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
#> # A tibble: 15,161 x 6
#>    bids_price bids_qty   bids.3 asks_price asks_qty   asks.3
#>    <chr>      <chr>       <int> <chr>      <chr>       <int>
#>  1 46459.71   0.14734789      2 46459.72   0.00006373      1
#>  2 46458.74   0.013724        1 46462.82   0.002609        1
#>  3 46456.31   0.001           1 46463.29   0.00006372      1
#>  4 46456.3    0.15269         1 46465.69   0.01028336      1
#>  5 46454.06   2.05429906      1 46466.85   0.00006371      1
#>  6 46452.84   0.00991817      1 46467.12   0.01063         1
#>  7 46452.32   0.04822396      1 46469.19   0.002           1
#>  8 46451.49   0.47200642      1 46469.69   0.00219         1
#>  9 46451.23   0.18756226      1 46469.88   0.008           1
#> 10 46451.22   0.1             1 46470.42   0.00006371      1
#> # ... with 15,151 more rows
```

View candle information (OHLC):

``` r
public_candles("gemini", time_frame = "1m") %>% 
  head(1)
#> [[1]]
#> [[1]][[1]]
#> [1] 1640992680000
#> 
#> [[1]][[2]]
#> [1] 46454.39
#> 
#> [[1]][[3]]
#> [1] 46468.95
#> 
#> [[1]][[4]]
#> [1] 46454.39
#> 
#> [[1]][[5]]
#> [1] 46459.78
#> 
#> [[1]][[6]]
#> [1] 0.249033
```

View recent trades:

``` r
public_trades(exchange = "kraken")
#> # A tibble: 1,000 x 6
#>    price       volume            time side  type  misc 
#>    <chr>       <chr>            <dbl> <chr> <chr> <chr>
#>  1 46335.40000 0.00088866 1640988211. b     m     ""   
#>  2 46335.40000 0.00282223 1640988211. b     m     ""   
#>  3 46335.40000 0.00088199 1640988215. b     m     ""   
#>  4 46335.40000 0.00159155 1640988215. b     m     ""   
#>  5 46335.40000 0.00010000 1640988215. b     m     ""   
#>  6 46335.80000 0.00719646 1640988215. b     m     ""   
#>  7 46335.80000 1.00000000 1640988229. b     l     ""   
#>  8 46335.80000 0.00208816 1640988230. b     l     ""   
#>  9 46335.80000 0.00225887 1640988230. b     l     ""   
#> 10 46335.80000 0.00010725 1640988230. b     l     ""   
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
