# All versions in the community created in the config's from/to range, as parquet files
# in `dir`. Only downloads when the check says so. Downloads into a temporary folder that
# replaces `dir` only when complete, so an interrupted download leaves the old data intact.
fetch_zenodo <- function(cfg, check, dir) {
  if (!check$refetch && zenodo_cached(dir)) return(dir)
  tmp <- paste0(dir, ".tmp")
  unlink(tmp, recursive = TRUE)
  dir.create(tmp, recursive = TRUE)
  fetch_zenodo_range(cfg, tmp, cfg$from, cfg$to)
  ids <- dplyr::collect(dplyr::select(arrow::open_dataset(tmp), id))$id
  stopifnot(!anyDuplicated(ids))
  unlink(dir, recursive = TRUE)
  file.rename(tmp, dir)
  dir
}
