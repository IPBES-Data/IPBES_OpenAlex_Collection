create_collection <- function(cfg, ids_file, folder) {
  ids <- arrow::read_parquet(ids_file)
  # Concept DOIs: always resolve to the newest version; OpenAlex uses them as the
  # main DOI of the merged work.
  # corpus = "all": core + expansion. Most Zenodo deposits are only in the expansion.
  q <- pro_query(
    doi = unique(na.omit(ids$conceptdoi)),
    chunk_limit = 500,
    options = list(corpus = "all")
  )
  pro_collection(
    q,
    select = c("id", "doi"),
    name = cfg$collection_name,
    project_folder = folder,
    verbose = TRUE,
    api_key = api_key("API_openalex_personal"),
    access = "shared_by_link"
  )
}
