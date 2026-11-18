# README.md with the last successful run and simple stats per config entry.
write_readme <- function(cfgs, collection_dirs, file = "README.md") {
  rows <- vapply(names(cfgs), \(name) {
    cfg <- cfgs[[name]]
    z <- arrow::read_parquet(file.path("output", name, "zenodo", "zenodo_ids.parquet"))
    col <- jsonlite::read_json(
      file.path("output", name, paste0(cfg$collection_name, ".collection"), "_collection.json")
    )
    range <- paste(cfg$from %||% "start", "–", cfg$to %||% "now")
    sprintf(
      "| %s | [%s](https://zenodo.org/communities/%s) | %s | %d | %d | %d | [%s](%s) | %s |",
      name, cfg$zenodo_community, cfg$zenodo_community, range,
      nrow(z), length(unique(z$conceptdoi)), col$member_count,
      col$collection_id, col$collection_url, col$access
    )
  }, "")
  writeLines(c(
    "# IPBES OpenAlex Collections",
    "",
    "OpenAlex collections of the deposits in Zenodo communities, updated daily by a GitHub Action.",
    "",
    sprintf("**Last successful run:** %s UTC", format(Sys.time(), "%Y-%m-%d %H:%M", tz = "UTC")),
    "",
    "| Config | Zenodo community | Created | Zenodo records (all versions) | Concepts (deposits) | OpenAlex works | Collection | Access |",
    "|---|---|---|---:|---:|---:|---|---|",
    rows,
    "",
    "## How it works",
    "",
    "A [targets](https://docs.ropensci.org/targets/) pipeline (`_targets.R`), one set of targets per entry in `config.yml`:",
    "",
    "1. `zenodo_check_<name>`: counts the community's records on Zenodo (2 requests): additions since the last download, removals = old + additions - new.",
    "2. `zenodo_ids_<name>`: downloads all versions of all deposits when the check finds a change (`output/<name>/zenodo/zenodo_ids.parquet`).",
    "3. `openalex_collection_<name>`: builds the OpenAlex collection from the unique concept DOIs (newest version of each deposit) with [openalexPro](https://openalexpro.r-universe.dev), searching all OpenAlex corpora (core + expansion).",
    "",
    "Run locally with `targets::tar_make()`. API keys are read from the environment variables (or keyring entries) `API_zenodo_ro` and `API_openalex_personal`."
  ), file)
  file
}
