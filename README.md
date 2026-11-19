# IPBES OpenAlex Collections

OpenAlex collections of the deposits in Zenodo communities, updated by [zenodo-openalex-collection](https://github.com/rkrug/zenodo-openalex-collection).

**Last successful run:** 2026-11-19 11:47 UTC (pipeline runtime 6.3 min)

| Config | Zenodo community | Created | Zenodo records (all versions) | Deposits with a version in range | Deposits first created in range | OpenAlex works | Last change on Zenodo | Collection | Access |
|---|---|---|---:|---:|---:|---:|---|---|---|
| ipbes | [ipbes](https://zenodo.org/communities/ipbes) | start – now | 1034 | 567 | 567 | 565 | 2026-11-19 11:23: +0 / −0 deposits (+0 / −0 records) | [col_GG6iTenVqa](https://openalex.org/collections/col_GG6iTenVqa) | shared_by_link |

## How it works

A [targets](https://docs.ropensci.org/targets/) pipeline from [zenodo-openalex-collection](https://github.com/rkrug/zenodo-openalex-collection), one set of targets per entry in `config.yml`:

1. `zenodo_check_<name>`: counts the community's records (all versions) on Zenodo for each month of the range (1 request per month) and compares them with the downloaded months.
2. `zenodo_ids_<name>`: downloads only the months whose counts changed, as parquet files of at most 10,000 records (`output/<name>/zenodo/<YYYY-MM>/`).
3. `openalex_collection_<name>`: builds the OpenAlex collection with [openalexPro](https://openalexpro.r-universe.dev) from the concept DOIs (they resolve to the newest version) of the deposits whose first version was created in the range, searching all OpenAlex corpora (core + expansion).

The data (`output/`) and the targets store (`_targets/`) are kept in the latest `data-*` release, not in git. Each run restores them from there and publishes a new release only when `output/` changed (the 3 newest are kept).

Setup and local runs: see [zenodo-openalex-collection](https://github.com/rkrug/zenodo-openalex-collection#readme).
