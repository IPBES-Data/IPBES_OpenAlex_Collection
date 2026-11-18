# All records created in [from, to). Zenodo returns at most 10,000 results per search,
# so larger ranges are halved until each piece fits.
fetch_zenodo_range <- function(cfg, from = NULL, to = NULL, limit = 10000) {
  q <- zenodo_query(from, to)
  n <- zenodo_count(cfg, q)
  if (n >= limit) {
    t <- function(x, default) as.POSIXct(x %||% default, tz = "UTC")
    lo <- t(from, "2013-01-01") # Zenodo launch
    hi <- t(to, as.character(Sys.Date() + 1))
    if (difftime(hi, lo, units = "secs") < 1) stop("10,000+ records within one second: ", q)
    mid <- format(lo + (hi - lo) / 2, "%Y-%m-%dT%H:%M:%S", tz = "UTC")
    return(c(fetch_zenodo_range(cfg, from, mid, limit), fetch_zenodo_range(cfg, mid, to, limit)))
  }
  size <- if (nzchar(api_key("API_zenodo_ro"))) 100 else 25 # anonymous max is 25
  hits <- list()
  res <- zenodo_get(zenodo_url(cfg), allversions = "true", size = size, sort = "oldest", q = q)
  repeat {
    hits <- c(hits, res$hits$hits)
    message(q, ": ", length(hits), " / ", res$hits$total)
    if (is.null(res$links[["next"]])) break
    res <- zenodo_get(res$links[["next"]])
  }
  stopifnot(length(hits) == res$hits$total)
  hits
}
