# Cheap check (2 requests) within the config's from/to range:
# additions = records created after the newest cached one,
# removals = old + additions - new. Anything non-zero -> full re-fetch.
# Negative removals mean records added to the community that were created earlier.
check_zenodo <- function(cfg, dir) {
  range <- zenodo_query(cfg$from, cfg$to)
  new <- zenodo_count(cfg, range)
  if (!zenodo_cached(dir)) {
    return(list(old = NA, new = new, additions = NA, removals = NA, refetch = TRUE))
  }
  old <- arrow::open_dataset(dir) |>
    dplyr::summarise(n = dplyr::n(), last = max(created)) |>
    dplyr::collect()
  additions <- zenodo_count(cfg, sprintf('%s AND created:{"%s" TO *]', range, old$last))
  removals <- old$n + additions - new
  res <- list(old = old$n, new = new, additions = additions, removals = removals,
              refetch = additions != 0 || removals != 0)
  message(sprintf("%s: old %d, new %d, additions %d, removals %d",
                  cfg$zenodo_community, res$old, new, additions, removals))
  res
}
