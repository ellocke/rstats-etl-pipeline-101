[![pipeline status](https://gitlab.com/fubits/rstats-poorman-spreadsheets-etl-101/badges/main/pipeline.svg)](https://gitlab.com/fubits/rstats-poorman-spreadsheets-etl-101/-/commits/main)

# How To: Minimal Data Pipeline with R & Google Spreadsheets ({poorman} fork)

## Purpose

This is a minimal automated data pipeline that demonstrates how to use R & Github Actions to read from/ write to a private Google Spreadsheet.

The [original repository](https://gitlab.com/fubits/rstats-spreadsheets-etl-101/) was built for a client workshop on Data-centric CI/CD & DevOps (2021-05). The ETL pipeline concept was demonstrated with **GitLab CI/CD** and the **`R`** language.

> This hard copy of the original repository was modified to use the lightweight and more performant [`{poorman}`](https://github.com/nathaneastwood/poorman) package. `{poorman}` is a pure base-R implementation of {dplyr} functionality.

> However, since we're still using `{googlesheets4}` from the Tidyverse ecosystem in this example, the runner initialization actually **takes longer** than with the `rocker/tidyverse` Docker image. The reason is that `{googlesheets4}` depends on some {tidyverse} packages such as `{tibble}, {jsonlite}, {vctrs}, {purrr}` aaand lastly the foreign `{curl}` and `{httr}` packages. Also, `{curl}` depends on `libcurl4-openssl-dev` and `{httr}` depends on `libssl-dev` (Debian libraries) which we need to pre-install with `apt-get` in an extra `before_script` job step. \*This is a good case for composing your **own Docker image\***.

The repo provides the minimum viable setup for a simple, secured, DIY **ETL** pipeline (extract-transform-load) based on:

- ~~`R` & `Tidyverse` (via [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse) Docker image)~~
- `R` & [`{poorman}`](https://github.com/nathaneastwood/poorman) (via [nathaneastwood/poorman](https://hub.docker.com/r/nathaneastwood/poorman/)) Docker image
- the [`googlesheets4`](https://googlesheets4.tidyverse.org/) package
- and a toy **Google Spreadsheet** (for input and output)

## Quick Start

- fork / `git clone` / download repo
- add following environment variables to the GitLab CI/CD settings (_Sidebar: Settings > CI/CD_):
  - Variable (_protected and masked_): `SHEETID"
    - Content: `<spreadsheetID>` (the ID of your Spreadsheet which is part of the URL)
  - File (_protected_): `TOKEN`
    - Content: `JSON` / `<content of token.json>`<br>(For obtaining the `JSON` Token see [Authentication](#authentication) section below.)
- modify / run (see [Operations](#operations))
- _Point of Entry_ for the pipeline is `R/00-main.R`

## Setup

### Spreadsheet

- create private Google Spreadsheet and grab the spreadsheet ID (from the URL)
- add some data to the Spreadsheet for the import step in `R/02-process-data.R` and adjust Sheet (tab) names.

### Authentication

> Since we want to keep the Spreadsheet private / restricted, we need a way to authenticate the `googlesheets4` R package for the Google Spreadsheet API. We do **not** want to include the Auth Token / Credentials in the repository for obvious Information Security reasons (credentials leaking). Therefore we'll be using the `Service Account` approach and will pass the content of the `json` token as a protected **File Variable** to `R` and extract it with `Sys.getenv("TOKEN")`.

> FYI: even if your Spreadsheet isn't private, you would still need a Token for _writing_ to it.

- short **file-token based** instruction: [How to Grant an Access for R googlesheets4 package Using Google Cloud Platform Service Account](https://cuberoot31.com/how-to-grant-an-access-to-r-googlesheets4-package-using-gcp-service-account/)
- [longer but slightly insufficient instruction from the `gargle` R package vignette](https://gargle.r-lib.org/articles/get-api-credentials.html#service-account-token-1) on how to obtain the **Service Account** token for Google Cloud Projects
  - _insufficient_ since it lacks the final step: _sharing the Spreadsheet with the Service Account Email_ (there's an [Git issue](https://github.com/tidyverse/googlesheets4/issues/170#issuecomment-832071335) for that)
- **important / Security Note**: for local development, you need to authenticate as well. My approach:
  - add to _Project-folder_ ~~`.Rprofile`~~ `.Renviron` (already in `.gitignore`):
    - SHEETID=\<sheetID\>
    - TOKEN=<path-to-auth-token.json>
  - **PSA**: add to `.git/info/exclude`:
    - `<path-to-auth-token.json>`
    - This way the local Token file will not be included in the repository and it's filename and existence is masked (i.e. it's not mentioned in `.gitignore`)

**PSA: Never `git add .` credentials to the repository**. If you did this by mistake, rewrite the git history (bad) or re-init the repo.

## Operations

- either trigger the pipeline manually (Sidebar > CI/CD > Pipelines > [Run Pipeline])
- or make changes to `R/*.R` and push (currently, this is _explicitly_ the only allowed rule to trigger a Pipeline run; cf. [Changelog](#changelog))
- to adjust pipeline edit `.gitlab-ci.yml` which is the CI/CD pipeline configuration (in YAML)
- _Point of Entry_ for the pipeline is `R/00-main.R`

## License / Attribution

I don't know much about non-CC licenses (yet) but since this is more of an educational piece of work than original code, feel free to just attribute me with my Twitter account ([twitter.com/fubits](https://twitter.com/fubits)) _modelled_ after [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). After all, I'm a [freelance](https://dadascience.design/portfolio/) 👨‍💻.

## Roadmap

> Repo will be occasionally maintained (e.g. for my future self)

- [x] implement a fork with the [`{poorman}`](https://github.com/nathaneastwood/poorman) package instead of {tidyverse}
- [x] implement a workflow with Github Actions instead of GitLab CI/CD
- [ ] split R "pipe" into the **ETL pipeline stages** (extract - transform - load)
- [ ] add **second Spreadsheet** and refactor to:
  - [ ] fetch from Spreadsheet 1
  - [ ] write to Spreadsheet 2
- [ ] add example for working with **artifacts**
  - [ ] i.e. a production example I did: produce `CSV` & `ZIP` outputs and `git commit/push` to _another repository_
- [ ] add example for incorporating `Shell / Bash` into the pipe (i.e. for the `git commit` part above)
- [ ] add examples for **testing** in the context of Data DevOps / Pipelines (FYI: brilliant [intro to data validation](https://emilyriederer.netlify.app/post/data-error-gen/) in the ETL context by Emily Riederer)

## Contributing

Feel free to file Git Issues for _reasonable_ feature requests (this is pipe is supposed to stay [KISS-simple](https://en.wikipedia.org/wiki/KISS_principle)) or point me to stuff that you built.

## Changelog

- 2022-03-14: added a Github Actions based workflow on [Github](https://github.com/ellocke/rstats-etl-pipeline-101)
- 2021-05-31: added a [`{renv}`](https://github.com/nathaneastwood/poorman) local dependency management [fork/example](https://gitlab.com/fubits/rstats-renv-spreadsheets-etl-101) for stable package dependencies management (incl. a caching strategy for CI/CD)
- 2021-05-31: switched local ${VAR} provision from `.Rprofile` to `.Renviron` (more natural and non-blocking for user-level `.Rprofile`)
- 2021-05-31: added a [`{poorman}`](https://github.com/nathaneastwood/poorman) fork of the pipeline part (incl. `apt-get install` of Debian dependencies)
- 2021-05-27: added minimum viable **Documentation** (this Readme)
- 2021-05-27: added `rules: changes: R/*.R` to `.gitlab-ci.yml`
  - This way, Pipeline should only be triggered on changes to R Production code in `R/*.R` (and not on i.e. cosmetic changes to the Readme or development code in `dev-notebooks/`)
- 2021-05-27: refactored, "rebased" (`rm -rf .git`) and cleaned up Pipeline history. Pipeline history is currently non-public until it is proven that a public pipeline history does not expose any credentials
- 2021-05-26: initial commit for the workshop
