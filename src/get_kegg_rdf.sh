#!/bin/bash
#
# bash script to query linkages between KO terms to biochemical reations to KEGG pathway 
# form the api and transformed into .ttl with defined terms including 'sio' and 'dc' 
# using awk commands.

set -e

DATA_DIR=$1
tmp_kegg_DATA_DIR=$2 

if [ "${DATA_DIR}" != "" ]; then
	mkdir -p $DATA_DIR && cd $DATA_DIR
fi


# the queried info will be stored in a temporary directory.
mkdir tmp_kegg

# make the prefixes for the ttl file 

echo "@prefix ko: <http://purl.uniprot.org/ko/>	.
@prefix dc: <http://purl.org/dc/elements/1.1/>	.
@prefix rn: <http://www.kegg.jp/entry/>	.
@prefix sio: <http://semanticscience.org/resource/>	.
@prefix path: <http://www.kegg.jp/entry/>	.
@prefix ath: <http://purl.uniprot.org/kegg/ath:>	.
"  > tmp_kegg/prefix_head.kegg

# Attention: the queiried info containes double quotes (")
# change them into ('')
curl  http://rest.kegg.jp/list/ko | awk -F"\t" '{\
split($1,res,":"); \
split($2,res_2,";"); \
gsub("\"", "'\'\''", res_2[2]); \ 
print $1 "\tdc:identifier\t\"" res[2] "\"^^string\t;\n" \
"\t\trdfs:label\t\"" res_2[1] "\"^^string\t;\n" \
"\t\tdc:description\t\"" res_2[2] "\"^^string\t."\
}'  > tmp_kegg/ko.kegg

curl http://rest.kegg.jp/list/reaction | awk -F"\t" '{\
split($1,res,":"); \
print $1 "\trdf:type\tsio:SIO_010036\t;\n" \
"\t\tdc:identifier\t\"" res[2]"\"^^string\t;\n"\
"\t\tdc:description\t\"" $2 "\"^^string\t."\
}' > tmp_kegg/rn.kegg


curl http://rest.kegg.jp/list/path | awk -F"\t" '{\
split($1, res, ":"); \
print $1 "\trdf:type\t" "sio:SIO_001107\t;\n"\
"\t\tdc:identifier\t" "\"" res[2] "\"^^string\t;\n"\
"\t\tdc:description\t" "\"" $2 "\"^^string\t."\
}' > tmp_kegg/pathway.kegg


curl http://rest.kegg.jp/link/reaction/ko | awk -F"\t" '{\
print $1 "\tsio:SIO_000068\t" $2 "\t."\
}' > tmp_kegg/ko_to_reaction.kegg

curl http://rest.kegg.jp/link/path/reaction | awk -F"\t" \
'NR%2 ==1 {\
print $1 "\tsio:SIO_000068\t" $2 "\t."\
}' > tmp_kegg/reaction_to_pathway.kegg

curl http://rest.kegg.jp/link/pathway/ath | awk -F"\t" '{
gsub("path:ath", "path:map", $2);
print $1 "\tsio:SIO_000062\t" $2 "\t."
}' >  tmp_kegg/gene_to_pathway.kegg


# curl http://rest.kegg.jp/link/ko/ath  | awk -F"\t" '{\
# print $1 "\tsio:SIO_000068\t" $2 "\t."\
# }' > tmp_kegg/gene_to_ko.ttl
# cat ko_description | grep '\[EC:.*\]' | sed 's/\t.*\[EC:/\t/g' | sed 's/\]//g' | awk -F"\t" '{n=split($2,res_arr," "); for(i=1; i<n; i++){print $1 "\tsio:SIO_000283\tec:" res_arr[i] }}' > tmp_kegg/ko_to_ec.ttl

cat tmp_kegg/prefix_head.kegg tmp_kegg/ko.kegg tmp_kegg/rn.kegg tmp_kegg/pathway.kegg \
tmp_kegg/ko_to_reaction.kegg tmp_kegg/reaction_to_pathway.kegg tmp_kegg/gene_to_pathway.kegg > kegg_pathway.ttl

gzip kegg_pathway.ttl
echo "http://www.kegg.jp/rest_api" > kegg_pathway.ttl.graph

rm -r tmp_kegg/




