#' Send API request
#'
#' @param base_url API endpoint
#' @param path_append Any additional paths for API call
#' @param query_params Any additional query parameters for API call
#' @param dry_run If TRUE, call httr2::req_dry_run, which shows the API call without actually sending it.
#'
#' @return
#'
get_api_response <- function(base_url, path_append, query_params = NULL, dry_run = FALSE) {
  resp <- httr2::request(base_url) %>%
    httr2::req_user_agent("cryptoapi (https://github.com/cstjohn810/cryptoapi)") %>%
    httr2::req_url_path_append(path_append) %>%
    httr2::req_url_query(!!!query_params)

  if (dry_run == FALSE) {
    resp %>%
      httr2::req_perform() %>%
      httr2::resp_body_json()
  } else {
    resp %>%
      httr2::req_dry_run()
  }

}
