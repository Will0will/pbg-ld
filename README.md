This repository is a fork form original [Linked Data Platform for Plant Breeding & Genomics](https://github.com/candYgene/pbg-ld). This repository has been adpated to the genome of Arabidopsis.  


## Prerequisites
- [GNU Make](https://www.gnu.org/software/make/)
- [Docker CE](https://docs.docker.com/install/)
- [cURL](https://curl.haxx.se/)

## Installation

**1. Clone this git repo.**

`git clone https://github.com/Will0will/pbg-ld.git`

**2. Start a [Docker container](https://hub.docker.com/r/candygene/docker-virtuoso/) with [Virtuoso Universal Server](http://virtuoso.openlinksw.com/) & ingest data in [RDF](https://www.w3.org/RDF/).**

```
cd pbg-ld/src
make all # with defaults: CONTAINER_NAME=virtuoso and CONTAINER_PORT=8890 (in development)
```

Note: other `make` rules: `pull-image`, `build-image`, `start-srv`, `stop-srv`, `restart-srv`, `install-pkgs`, `get-rdf`, `import-rdf`, `update-rdf`, `post-install` and `clean`.

**3. [Login](http://localhost:8890/conductor) to running Virtuoso instance for admin tasks.**

Use `dba` for both account name and password.

**4. Run queries via Virtuoso [SPARQL endpoint](http://localhost:8890/sparql) or browse data via [Faceted Browser](http://localhost:8890/fct/) (no login required).**

The adaption is still under construction. Further details can be found on the [wiki](../../wiki).
