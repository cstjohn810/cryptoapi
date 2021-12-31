
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
#> [1] 46346.36
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
#> [1] 46355
#> 
#> $result$bid
#> [1] 46352
#> 
#> $result$ask
#> [1] 46353
#> 
#> $result$price
#> [1] 46353
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
#> [1] 0.009726291
#> 
#> $result$change24h
#> [1] -0.01817373
#> 
#> $result$changeBod
#> [1] -0.01823612
#> 
#> $result$quoteVolume24h
#> [1] 546828689
#> 
#> $result$volumeUsd24h
#> [1] 546828689
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
#> # A tibble: 15,459 x 6
#>    bids_price bids_qty   bids.3 asks_price asks_qty   asks.3
#>    <chr>      <chr>       <int> <chr>      <chr>       <int>
#>  1 46358.61   0.01864899      1 46360.68   0.01612281      1
#>  2 46358.6    0.04297742      1 46362.03   0.25891967      1
#>  3 46358.43   0.1             1 46362.79   0.01864899      1
#>  4 46358.31   0.0005          1 46362.8    0.05            1
#>  5 46358.3    0.00081085      1 46362.81   0.02105         1
#>  6 46358.26   0.0005          1 46363.86   0.001           1
#>  7 46358.21   0.0005          1 46363.88   0.153013        1
#>  8 46352.68   0.00006359      1 46364.34   0.00206456      1
#>  9 46350.56   0.45867155      2 46365.75   0.01589         1
#> 10 46350.5    0.031           1 46367.07   0.05393087      1
#> # ... with 15,449 more rows
```

View candle information (OHLC):

``` r
public_candles("gemini", time_frame = "1m") %>% 
  head(1)
#> [[1]]
#> [[1]][[1]]
#> [1] 1640989920000
#> 
#> [[1]][[2]]
#> [1] 46382.89
#> 
#> [[1]][[3]]
#> [1] 46382.89
#> 
#> [[1]][[4]]
#> [1] 46370.9
#> 
#> [[1]][[5]]
#> [1] 46370.9
#> 
#> [[1]][[6]]
#> [1] 0.05564079
```

View recent trades:

``` r
public_trades(exchange = "kraken")
#> # A tibble: 1,000 x 6
#>    price       volume            time side  type  misc 
#>    <chr>       <chr>            <dbl> <chr> <chr> <chr>
#>  1 46431.70000 0.10080865 1640986653. b     m     ""   
#>  2 46433.00000 0.08800000 1640986653. b     m     ""   
#>  3 46434.90000 0.00039558 1640986653. b     m     ""   
#>  4 46437.70000 0.08800000 1640986653. b     m     ""   
#>  5 46439.80000 0.25000000 1640986653. b     m     ""   
#>  6 46442.40000 0.08800000 1640986653. b     m     ""   
#>  7 46442.50000 0.89883832 1640986653. b     m     ""   
#>  8 46442.50000 3.41132380 1640986653. b     m     ""   
#>  9 46443.00000 0.14599130 1640986653. b     m     ""   
#> 10 46443.00000 0.00500000 1640986653. b     m     ""   
#> # ... with 990 more rows
```
