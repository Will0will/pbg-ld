#!/bin/bash
#
# Batch script to download (compressed) data in RDF and to write graph URIs into *.graph files
# required for loading RDF into Virtuoso RDF Quad Store.

set -ev

ENSEMBLPLANTS_RELEASE=33
#UNIPROT_RELEASE=2016_11
DATA_DIR=$1

if [ "${DATA_DIR}" != "" ]; then
	mkdir -p $DATA_DIR && cd $DATA_DIR
fi

# download ontologies
curl --stderr - -LH "Accept: application/rdf+xml" -o faldo.rdf "http://biohackathon.org/resource/faldo.rdf" \
	&& echo "http://biohackathon.org/resource/faldo.rdf" > faldo.rdf.graph

curl --stderr - -LH "Accept: application/rdf+xml" -o so.rdf "http://purl.obolibrary.org/obo/so.owl" \
	&& echo "http://purl.obolibrary.org/obo/so.owl" > so.rdf.graph

curl --stderr - -LH "Accept: application/rdf+xml" -o sio.rdf "http://semanticscience.org/ontology/sio.owl" \
	&& echo "http://semanticscience.org/ontology/sio.owl" > sio.rdf.graph

curl --stderr - -LH "Accept: application/rdf+xml" -o ro.rdf "http://purl.obolibrary.org/obo/ro.owl" \
	&& echo "http://purl.obolibrary.org/obo/ro.owl" > ro.rdf.graph

curl --stderr - -o uniprot_core.rdf "ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/rdf/core.owl" \
	&& echo "http://purl.uniprot.org/core/" > uniprot_core.rdf.graph

curl --stderr - -LH "Accept: application/rdf+xml" -o go.rdf "http://purl.obolibrary.org/obo/go.owl" \
	&& echo "http://purl.obolibrary.org/obo/go.owl" > go.rdf.graph

curl --stderr - -LH "Accept: application/rdf+xml" -o po.rdf "http://purl.obolibrary.org/obo/po.owl" \
        && echo "http://purl.obolibrary.org/obo/po.owl" > po.rdf.graph

curl --stderr - -LH "Accept: application/rdf+xml" -o to.rdf "http://purl.obolibrary.org/obo/to.owl" \
        && echo "http://purl.obolibrary.org/obo/to.owl" > to.rdf.graph

curl --stderr - -LH "Accept: application/rdf+xml" -o goslim_generic.rdf "http://current.geneontology.org/ontology/subsets/goslim_generic.owl" \
	&& echo "http://geneontology.com/ontology/subset/goslim_generic.owl" > goslim_generic.rdf.graph

# download arabidopsis genome and proteome from Ensembl Plants and UniProt Reference Proteomes, respectively
curl --stderr - -LO "ftp://ftp.ensemblgenomes.org/pub/plants/release-${ENSEMBLPLANTS_RELEASE}/rdf/arabidopsis_thaliana/arabidopsis_thaliana.ttl.gz" \
	&& echo "http://plants.ensembl.org/arabidopsis_thaliana" > arabidopsis_thaliana.ttl.graph

curl --stderr - -LO "ftp://ftp.ensemblgenomes.org/pub/plants/release-${ENSEMBLPLANTS_RELEASE}/rdf/arabidopsis_thaliana/arabidopsis_thaliana_xrefs.ttl.gz" \
	&& echo "http://plants.ensembl.org/arabidopsis_thaliana" > arabidopsis_thaliana_xrefs.ttl.graph

curl --stderr - -L -o uniprot_arabidopsis.rdf.gz "http://www.uniprot.org/uniprot/?format=rdf&compress=yes&query=proteome:UP000006548" \
	&& echo "http://uniprot.org/proteomes/arabidopsis_thaliana" > uniprot_arabidopsis.rdf.graph

gzip *.rdf
