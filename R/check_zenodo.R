# Cheap check (2 requests) within the config's from/to range:
# additions = records created after the newest cached one,
# removals = old + additions - new. Anything non-zero -> full re-fetch.
# Negative removals mean records added to the community that were created earlier.
check_zenodo <- function(cfg, file) {
  range <- zenodo_query(cfg$from, cfg$to)
  new <- zenodo_count(cfg, range)
  if (!file.exists(file)) {
    return(list(old = NA, new = new, additions = NA, removals = NA, refetch = TRUE))
  }
  old <- arrow::read_parquet(file)
  additions <- zenodo_count(
    cfg, sprintf('%s AND created:{"%s" TO *]', range, max(old$created))
  )
  removals <- nrow(old) + additions - new
  res <- list(old = nrow(old), new = new, additions = additions, removals = removals,
              refetch = additions != 0 || removals != 0)
  message(sprintf("%s: old %d, new %d, additions %d, removals %d",
                  cfg$zenodo_community, res$old, new, additions, removals))
  res
}
