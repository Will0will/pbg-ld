-- 
-- Fix database cross-references in EnsemblPlants RDF graph.
--

log_enable(2) ; -- disable transaction logging & enable row-by-row autocommit
SET u{BASE_URI} http://localhost:8890 ;
SET u{ENSEMBL_RELEASE} 33 ;
SET u{ENSEMBL_G_URI} http://plants.ensembl.org/Solanum_lycopersicum ;
SET u{SGN-SL_G_URI} http://solgenomics.net/genome/Solanum_lycopersicum ;
SET u{SGN-SP_G_URI} http://solgenomics.net/genome/Solanum_pennellii ;
SET u{EPMC_G_URI} http://europepmc.org/articles ;

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

SPARQL
WITH <$u{ENSEMBL_G_URI}>
DELETE { ?s <http://semanticscience.org/resource/SIO:000630> ?o }
INSERT { ?s <http://semanticscience.org/resource/SIO_000630> ?o }
WHERE { ?s <http://semanticscience.org/resource/SIO:000630> ?o } ;

SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
WITH <$u{ENSEMBL_G_URI}>
DELETE { ?s rdfs:seeAlso ?o }
INSERT { ?s rdfs:seeAlso ?fixed }
WHERE {
   ?s rdfs:seeAlso ?o .
   FILTER regex(?o, 'http://identifiers.org/ensembl') .
   BIND(uri(replace(str(?o), 'ensembl', 'ensembl.plant')) AS ?fixed)
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


--
-- Add chromosome type to EnsemblPlants RDF graph.
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
INSERT INTO <$u{ENSEMBL_G_URI}> {
   ?chr2 a obo:SO_0000340
}  
WHERE {
   GRAPH <$u{SGN-SL_G_URI}> {
      ?chr1 a obo:SO_0000340 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl/$u{ENSEMBL_RELEASE}/solanum_lycopersicum/SL2.50/', replace(str(?chr1), '.+ch0?', ''))) AS ?chr2)
   }
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX obo: <http://purl.obolibrary.org/obo/>
--WITH  <$u{ENSEMBL_G_URI}>
--DELETE WHERE { ?s a obo:SO_0000340 } ;


--
-- Cross-link chromosomes in two RDF graphs.
--   graph URI: http://solgenomics.net/genome/Solanum_lycopersicum
--     chromosome URI: e.g. http://.../genome/Solanum_lycopersicum/chromosome/SL2.50ch01
--
--   graph URI: http://plants.ensembl.org/Solanum_lycopersicum
--     chromosome URI: e.g. http://rdf.ebi.ac.uk/resource/ensembl/33/solanum_lycopersicum/SL2.50/1
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
INSERT INTO <$u{SGN-SL_G_URI}> {
   ?chr1 owl:sameAs ?chr2
}   
WHERE {
   GRAPH <$u{SGN-SL_G_URI}> {
      ?chr1 a obo:SO_0000340 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl/$u{ENSEMBL_RELEASE}/solanum_lycopersicum/SL2.50/', replace(str(?chr1), '.+ch0?', ''))) AS ?chr2)
   }
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX owl: <http://www.w3.org/2002/07/owl#>
--WITH  <$u{SGN-SL_G_URI}>
--DELETE WHERE { ?s owl:sameAs ?o } ;


--
-- Link chromosomes to ENA accessions.
--

SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sgn-chr: <$u{BASE_URI}/genome/Solanum_lycopersicum/chromosome/>
PREFIX ena: <http://identifiers.org/ena.embl/>
INSERT INTO <$u{SGN-SL_G_URI}> {
   sgn-chr:SL2.50ch01 rdfs:seeAlso ena:CM001064.2 .
   sgn-chr:SL2.50ch02 rdfs:seeAlso ena:CM001065.2 .
   sgn-chr:SL2.50ch03 rdfs:seeAlso ena:CM001066.2 .
   sgn-chr:SL2.50ch04 rdfs:seeAlso ena:CM001067.2 .
   sgn-chr:SL2.50ch05 rdfs:seeAlso ena:CM001068.2 .
   sgn-chr:SL2.50ch06 rdfs:seeAlso ena:CM001069.2 .
   sgn-chr:SL2.50ch07 rdfs:seeAlso ena:CM001070.2 .
   sgn-chr:SL2.50ch08 rdfs:seeAlso ena:CM001071.2 .
   sgn-chr:SL2.50ch09 rdfs:seeAlso ena:CM001072.2 .
   sgn-chr:SL2.50ch10 rdfs:seeAlso ena:CM001073.2 .
   sgn-chr:SL2.50ch11 rdfs:seeAlso ena:CM001074.2 .
   sgn-chr:SL2.50ch12 rdfs:seeAlso ena:CM001075.2
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
--PREFIX ena: <http://identifiers.org/ena.embl/>
--WITH <$u{SGN-SL_G_URI}>
--DELETE { ?s rdfs:seeAlso ?o }
--WHERE { ?s rdfs:seeAlso ?o . FILTER regex(?o, ena:) } ;


--
-- Cross-link protein-coding genes in two RDF graphs.
--   graph URI: http://solgenomics.net/genome/Solanum_lycopersicum
--     gene URI: e.g. http://.../genome/Solanum_lycopersicum/gene/Solyc07g049530.2
--
--   graph URI: http://plants.ensembl.org/Solanum_lycopersicum
--     gene URI: e.g. http://rdf.ebi.ac.uk/resource/ensembl/Solyc07g049530.2
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
INSERT INTO <$u{SGN-SL_G_URI}> {
   ?gene1 owl:sameAs ?gene2
}
WHERE {  
   GRAPH <$u{SGN-SL_G_URI}> {
      ?gene1 a obo:SO_0001217 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl/', replace(str(?gene1), '.+/', ''))) AS ?gene2)
   }
   GRAPH <$u{ENSEMBL_G_URI}> {
      ?gene2 a obo:SO_0001217
   }
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX owl: <http://www.w3.org/2002/07/owl#>
--WITH  <$u{SGN-SL_G_URI}>
--DELETE WHERE { ?gene1 owl:sameAs ?gene2 } ;


--
-- Add primary trascript type to EnsemblPlants RDF graph.
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
INSERT INTO <$u{ENSEMBL_G_URI}> {
   ?chr2 a obo:SO_0000120
}  
WHERE {
   GRAPH <$u{SGN-SL_G_URI}> {
      ?chr1 a obo:SO_0000120 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl.transcript/', replace(str(?chr1), '.+/', ''))) AS ?chr2)
   }
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX obo: <http://purl.obolibrary.org/obo/>
--WITH  <$u{ENSEMBL_G_URI}>
--DELETE WHERE { ?s a obo:SO_0000120 } ;


--
-- Delete miRNA type for protein-coding primary transcripts.
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
WITH  <$u{ENSEMBL_G_URI}>
DELETE { ?s a obo:SO_0000276 }
WHERE { ?s a obo:SO_0000120 } ;


--
-- Cross-link transcripts in two RDF graphs.
--   graph URI: http://solgenomics.net/genome/Solanum_lycopersicum
--     transcript URI: e.g. http://.../genome/Solanum_lycopersicum/prim_transcript/Solyc02g079500.2.1
--
--   graph URI: http://plants.ensembl.org/Solanum_lycopersicum
--     transcript URI: e.g. http://rdf.ebi.ac.uk/resource/ensembl.transcript/Solyc02g079500.2.1
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
INSERT INTO <$u{SGN-SL_G_URI}> {
   ?chr1 owl:sameAs ?chr2
}   
WHERE {
   GRAPH <$u{SGN-SL_G_URI}> {
      ?chr1 a obo:SO_0000120 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl.transcript/', replace(str(?chr1), '.+/', ''))) AS ?chr2)
   }
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX owl: <http://www.w3.org/2002/07/owl#>
--WITH  <$u{SGN-SL_G_URI}>
--DELETE WHERE { ?s owl:sameAs ?o } ;


--
-- Link SGN markers common to both tomato species
--

SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX sio: <http://semanticscience.org/resource/>
INSERT INTO <$u{SGN-SL_G_URI}> {
   ?marker_sl sio:SIO_000558 ?marker_sp
}
WHERE {
   GRAPH <$u{SGN-SL_G_URI}> {
      ?marker_sl a obo:SO_0001645 ;
         rdfs:comment ?aliases_sl ;
         dct:identifier ?marker_sl_id .
   }
   GRAPH <$u{SGN-SP_G_URI}> {
      ?marker_sp a obo:SO_0001645 ;
         rdfs:comment ?aliases_sp ;
         dct:identifier ?marker_sp_id .
   }
   BIND(bif:strcontains(?aliases_sl, str(?marker_sp_id)) AS ?match)
   FILTER(?match = 1)
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX obo: <http://purl.obolibrary.org/obo/>
--PREFIX sio: <http://semanticscience.org/resource/>
--WITH  <$u{SGN-SL_G_URI}>
--DELETE WHERE {
--   ?s a obo:SO_0001645 ;
--      sio:SIO_000558 ?o
--} ;


--
-- Pre-compute QTLs' chromosomal locations based on flanking/peak markers' positions.
-- Note: If there are more than two markers per QTL, take the longest region delineated by the markers.
--

SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX faldo: <http://biohackathon.org/resource/faldo#>
PREFIX sgn-sly: <$u{BASE_URI}/genome/Solanum_lycopersicum/>
INSERT INTO <http://europepmc.org/articles> {
   ?qtl faldo:location ?qtl_loc .
   ?qtl_loc a faldo:Region ;
      rdfs:label ?chr_loc ;
      faldo:begin ?qtl_begin ;
      faldo:end ?qtl_end
}
WHERE {
   SELECT
      ?qtl
      concat(?chr_lb, ':', ?min_begin, '-', ?max_end) AS ?chr_loc
      uri(concat(?chr, '#', ?min_begin, '-', ?max_end)) AS ?qtl_loc
      uri(concat(?chr, '#', ?min_begin)) AS ?qtl_begin
      uri(concat(?chr, '#', ?max_end)) AS ?qtl_end
   WHERE {
      SELECT
         ?qtl
         ?chr_lb
         min(?begin_pos) AS ?min_begin
         max(?end_pos) AS ?max_end
         uri(concat(sgn-sly:, replace(GROUP_CONCAT(DISTINCT ?chr_lb, ''), '\\s+', '/'))) AS ?chr
      WHERE {
         GRAPH <$u{EPMC_G_URI}> {
            ?qtl a obo:SO_0000771 ;
               obo:RO_0002610 ?marker ;
               dct:identifier ?qtl_id .
            ?marker a obo:SO_0001645
         }
         GRAPH <$u{SGN-SL_G_URI}> {
            ?marker faldo:location ?loc .
            ?loc faldo:begin ?begin ;
                 faldo:end/faldo:position ?end_pos .
            ?begin faldo:position ?begin_pos ;
               faldo:reference/rdfs:label ?chr_lb
         }
      }
      GROUP BY ?qtl ?chr_lb
   }
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX faldo: <http://biohackathon.org/resource/faldo#>
--WITH <$u{EPMC_G_URI}>
--DELETE WHERE {
--  ?qtl faldo:location ?qtl_loc .
--  ?qtl_loc a faldo:Region ;
--     rdfs:label ?chr_loc ;
--     faldo:begin ?qtl_begin ;
--     faldo:end ?qtl_end
--} ;

--
-- Add genes that overlap with QTLs on the reference genome.
--

SPARQL
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX so: <http://purl.obolibrary.org/obo/so#>
PREFIX faldo: <http://biohackathon.org/resource/faldo#>
INSERT INTO <$u{EPMC_G_URI}> {
  ?qtl so:overlaps ?gene
}
WHERE {
   GRAPH <$u{EPMC_G_URI}> {
      ?qtl a obo:SO_0000771 ;
         faldo:location ?loc ;
         obo:RO_0003308 ?trait .
      ?loc faldo:begin ?begin ;
         faldo:end ?end
   }
   GRAPH <$u{SGN-SL_G_URI}> {
      ?begin faldo:position ?begin_pos ;
         faldo:reference ?chr .
      ?end faldo:position ?end_pos .
   }
   GRAPH <$u{SGN-SL_G_URI}> {
      ?loc2 faldo:begin ?begin2 ;
         faldo:end ?end2 ;
         ^faldo:location ?gene .
      ?gene a obo:SO_0001217 .
      ?begin2 faldo:position ?begin_pos2 ;
         faldo:reference ?chr2 .
      ?end2 faldo:position ?end_pos2 .
   }
   FILTER(?chr = ?chr2)
   FILTER((xsd:integer(?begin_pos) > xsd:integer(?begin_pos2) &&
           xsd:integer(?begin_pos) < xsd:integer(?end_pos2)) ||
          (xsd:integer(?end_pos) > xsd:integer(?begin_pos2) &&
           xsd:integer(?end_pos) < xsd:integer(?end_pos2)) ||
          (xsd:integer(?begin_pos) < xsd:integer(?begin_pos2) &&
          xsd:integer(?end_pos) > xsd:integer(?end_pos2)) ||
          xsd:integer(?begin_pos) > xsd:integer(?begin_pos2) &&
          xsd:integer(?end_pos) < xsd:integer(?end_pos2))
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX so: <http://purl.obolibrary.org/obo/so#>
--WITH <$u{EPMC_G_URI}>
--DELETE WHERE {
--  ?qtl so:overlaps ?gene
--} ;


--
-- Link QTLs to SGN's genome browser (JBrowse).
--

SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX faldo: <http://biohackathon.org/resource/faldo#>
INSERT INTO <$u{EPMC_G_URI}> {
   ?loc rdfs:seeAlso ?jbrowse
}
WHERE {
   GRAPH <$u{EPMC_G_URI}> {
      ?loc a faldo:Region ;
         rdfs:label ?loc_lb .
      BIND(uri(concat('https://solgenomics.net/jbrowse_solgenomics/?data=data/json/SL2.50&loc=', replace(replace(?loc_lb, '.+\\s+', ''), '-', '..'), '&tracks=DNA,gene_models')) AS ?jbrowse)
   }
} ;

--
-- Delete triples
--
--SPARQL
--PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
--PREFIX faldo: <http://biohackathon.org/resource/faldo#>
--WITH <$u{EPMC_G_URI}>
--DELETE { ?loc rdfs:seeAlso ?jbrowse }
--WHERE {
--   ?loc rdfs:seeAlso ?jbrowse ;
--      a faldo:Region
--} ;
