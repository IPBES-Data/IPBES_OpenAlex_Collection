# Downloads the months the check found changed into `dir`/<YYYY-MM>/. Each month is
# downloaded into a temporary folder that replaces the old month folder only when complete,
# so an interrupted download leaves the old data intact. Months now empty are removed.
fetch_zenodo <- function(cfg, changed, dir) {
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  unlink(list.files(dir, "[.]parquet$", full.names = TRUE)) # old flat layout
  tmp_root <- paste0(dir, ".tmp")
  na_null <- \(x) if (is.na(x)) NULL else x
  for (i in seq_len(nrow(changed))) {
    final <- file.path(dir, changed$month[i])
    tmp <- file.path(tmp_root, changed$month[i])
    unlink(tmp, recursive = TRUE)
    if (changed$new[i] > 0) {
      dir.create(tmp, recursive = TRUE)
      fetch_zenodo_range(cfg, tmp, na_null(changed$from[i]), na_null(changed$to[i]))
    }
    unlink(final, recursive = TRUE)
    if (dir.exists(tmp)) file.rename(tmp, final)
  }
  unlink(tmp_root, recursive = TRUE)
  ids <- dplyr::collect(dplyr::select(arrow::open_dataset(dir), id))$id
  stopifnot(!anyDuplicated(ids))
  dir
}
