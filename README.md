# IPBES OpenAlex Collections

OpenAlex collections of the deposits in Zenodo communities, updated daily by a GitHub Action.

**Last successful run:** 2026-11-19 09:31 UTC

| Config | Zenodo community | Created | Zenodo records (all versions) | Deposits with a version in range | Deposits first created in range | OpenAlex works | Collection | Access |
|---|---|---|---:|---:|---:|---:|---|---|
| ipbes | [ipbes](https://zenodo.org/communities/ipbes) | start – now | 1034 | 567 | 567 | 565 | [col_GG6iTenVqa](https://openalex.org/collections/col_GG6iTenVqa) | shared_by_link |

## How it works

A [targets](https://docs.ropensci.org/targets/) pipeline (`_targets.R`), one set of targets per entry in `config.yml`:

1. `zenodo_check_<name>`: counts the community's records on Zenodo (2 requests): additions since the last download, removals = old + additions - new.
2. `zenodo_ids_<name>`: downloads all versions of all deposits created in the range when the check finds a change, as parquet files of at most 1000 records (`output/<name>/zenodo/`).
3. `openalex_collection_<name>`: builds the OpenAlex collection with [openalexPro](https://openalexpro.r-universe.dev) from the concept DOIs (they resolve to the newest version) of the deposits whose first version was created in the range, searching all OpenAlex corpora (core + expansion).

The data (`output/`) and the targets store (`_targets/`) are kept in the latest `data-*` release, not in git. Each run restores them from there and publishes a new release only when `output/` changed (the 3 newest are kept).

Run locally with `targets::tar_make()`. API keys are read from the environment variables (or keyring entries) `API_zenodo_ro` and `API_openalex_personal`.
