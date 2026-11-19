# IPBES OpenAlex Collections

OpenAlex collections of the deposits in Zenodo communities, updated daily by a GitHub Action.

**Last successful run:** 2026-11-19 00:36 UTC

| Config | Zenodo community | Created | Zenodo records (all versions) | Concepts (deposits) | OpenAlex works | Collection | Access |
|---|---|---|---:|---:|---:|---|---|
| ipbes | [ipbes](https://zenodo.org/communities/ipbes) | start – now | 1034 | 567 | 565 | [col_GKr5zhrFBJ](https://openalex.org/collections/col_GKr5zhrFBJ) | shared_by_link |

## How it works

A [targets](https://docs.ropensci.org/targets/) pipeline (`_targets.R`), one set of targets per entry in `config.yml`:

1. `zenodo_check_<name>`: counts the community's records on Zenodo (2 requests): additions since the last download, removals = old + additions - new.
2. `zenodo_ids_<name>`: downloads all versions of all deposits when the check finds a change (`output/<name>/zenodo/zenodo_ids.parquet`).
3. `openalex_collection_<name>`: builds the OpenAlex collection from the unique concept DOIs (newest version of each deposit) with [openalexPro](https://openalexpro.r-universe.dev), searching all OpenAlex corpora (core + expansion).

Run locally with `targets::tar_make()`. API keys are read from the environment variables (or keyring entries) `API_zenodo_ro` and `API_openalex_personal`.
