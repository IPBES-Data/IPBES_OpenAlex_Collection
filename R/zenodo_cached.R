zenodo_cached <- function(dir) {
  length(list.files(dir, "[.]parquet$")) > 0
}
