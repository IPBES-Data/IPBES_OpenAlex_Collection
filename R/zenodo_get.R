# Sends the Zenodo token API_zenodo_ro when available (allows 100 records per page).
zenodo_get <- function(url, ...) {
  req <- httr2::request(url) |>
    httr2::req_url_query(...) |>
    httr2::req_retry(
      max_tries = 5,
      is_transient = \(r) httr2::resp_status(r) %in% c(429, 500, 502, 503, 504)
    ) |>
    httr2::req_error(body = \(r) httr2::resp_body_string(r))
  token <- api_key("API_zenodo_ro")
  if (nzchar(token)) req <- httr2::req_auth_bearer_token(req, token)
  req |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
