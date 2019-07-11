-- 
-- Fix database cross-references in EnsemblPlants RDF graph.
--

log_enable(2) ; -- disable transaction logging & enable row-by-row autocommit
SET u{BASE_URI} http://localhost:8890 ;
SET u{ENSEMBL_RELEASE} 33 ;
SET u{ENSEMBL_G_URI} http://plants.ensembl.org/arabidopsis_thaliana ;


SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
WITH <$u{ENSEMBL_G_URI}>
DELETE { ?s rdfs:seeAlso ?o }
INSERT { ?s rdfs:seeAlso ?fixed }
WHERE { 
   ?s rdfs:seeAlso ?o .
   FILTER regex(?o, 'http://identifiers.org/(go|kegg)') .
   BIND(uri(replace(str(?o), '%253A', ':')) AS ?fixed)
} ;


--
-- Fix SO predicates
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX so: <http://purl.obolibrary.org/obo/so#>
WITH <$u{ENSEMBL_G_URI}>
DELETE { ?s obo:SO_translates_to ?o }
INSERT { ?s so:translates_to ?o }
WHERE { ?s obo:SO_translates_to ?o } ;

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX so: <http://purl.obolibrary.org/obo/so#>
WITH <$u{ENSEMBL_G_URI}>
DELETE { ?s obo:SO_has_part ?o }
INSERT { ?s so:has_part ?o }
WHERE { ?s obo:SO_has_part ?o } ;

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX so: <http://purl.obolibrary.org/obo/so#>
WITH <$u{ENSEMBL_G_URI}>
DELETE { ?s obo:SO_transcribed_from ?o }
INSERT { ?s so:transcribed_from  ?o }
WHERE { ?s obo:SO_transcribed_from ?o } ;





