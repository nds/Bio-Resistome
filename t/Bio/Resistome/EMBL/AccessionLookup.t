#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use_ok('Bio::Resistome::EMBL::AccessionLookup');
}

ok my $lookup = Bio::Resistome::EMBL::AccessionLookup->new(
  accession_number => "U41471",
  _full_lookup_url => 't/data/U41471&display=xml'
), 'Initialise valid obj';
ok($lookup->accession_metadata, 'build the accession metadata');
is($lookup->_species, 'Mycobacterium fortuitum','Get the species');
is($lookup->_taxon_id, 1766, 'get the taxon id');
is_deeply($lookup->_lineage,
  [ 
     "Bacteria",
     "Actinobacteria",
     "Actinobacteridae",
     "Actinomycetales",
     "Corynebacterineae",
     "Mycobacteriaceae",
     "Mycobacterium"
  ], 'Get the lineage');
is_deeply($lookup->_pubmed_ids, [8891143], 'get the pubmed ids');
is($lookup->_description, "Mycobacterium fortuitum aminoglycoside 2'-N-acetyltransferase (aac(2')-Ib) gene, complete cds.", 'get description');

# Missing lineage
ok my $lookup_missing_lineage = Bio::Resistome::EMBL::AccessionLookup->new(
  accession_number => "U41471",
  _full_lookup_url => 't/data/U41471_missing_lineage.xml'
), 'Initialise missing lineage';
ok($lookup_missing_lineage->accession_metadata, 'build the accession metadata missing lineage');
is($lookup_missing_lineage->_species, 'Mycobacterium fortuitum','Get the species missing lineage');
is($lookup_missing_lineage->_taxon_id, 1766, 'get the taxon id missing lineage');
is_deeply($lookup_missing_lineage->_lineage, [], 'missing lineage');
is_deeply($lookup_missing_lineage->_pubmed_ids, [8891143], 'get the pubmed ids');
is($lookup_missing_lineage->_description, "Mycobacterium fortuitum aminoglycoside 2'-N-acetyltransferase (aac(2')-Ib) gene, complete cds.", 'get description missing lineage');

#  Missing source feature
ok my $lookup_missing_source_feature = Bio::Resistome::EMBL::AccessionLookup->new(
  accession_number => "U41471",
  _full_lookup_url => 't/data/U41471_missing_source_feature.xml'
), 'initialise missing source feature obj';
ok($lookup_missing_source_feature->accession_metadata, 'build the accession metadata missing source feature');
is($lookup_missing_source_feature->_species, undef,'Get the species missing source feature');
is($lookup_missing_source_feature->_taxon_id, undef, 'get the taxon id missing source feature');
is_deeply($lookup_missing_source_feature->_lineage, [], 'missing source feature');
is_deeply($lookup_missing_source_feature->_pubmed_ids, [8891143], 'get the pubmed ids');
is($lookup_missing_source_feature->_description, "Mycobacterium fortuitum aminoglycoside 2'-N-acetyltransferase (aac(2')-Ib) gene, complete cds.", 'get description missing source feature');

# Missing references
ok my $lookup_missing_references = Bio::Resistome::EMBL::AccessionLookup->new(
  accession_number => "U41471",
  _full_lookup_url => 't/data/U41471_missing_references.xml'
), 'Initialise valid obj missing references';
ok($lookup_missing_references->accession_metadata, 'build the accession metadata missing references');
is($lookup_missing_references->_species, 'Mycobacterium fortuitum','Get the species missing references');
is($lookup_missing_references->_taxon_id, 1766, 'get the taxon id missing references');
is_deeply($lookup_missing_references->_lineage,
  [ 
     "Bacteria",
     "Actinobacteria",
     "Actinobacteridae",
     "Actinomycetales",
     "Corynebacterineae",
     "Mycobacteriaceae",
     "Mycobacterium"
  ], 'Get the lineage missing references');
is_deeply($lookup_missing_references->_pubmed_ids, [], 'get the pubmed ids missing references');
is($lookup_missing_references->_description, "Mycobacterium fortuitum aminoglycoside 2'-N-acetyltransferase (aac(2')-Ib) gene, complete cds.", 'get description missing reference');

# Unknown accession number
ok my $lookup_unknown_accession= Bio::Resistome::EMBL::AccessionLookup->new(
  accession_number => "XXXXX",
  _full_lookup_url => 't/data/unknown_accession&display=xml'
), 'Initialise unknown accession';
ok($lookup_unknown_accession->accession_metadata, 'build with unknown accession number');
is($lookup_unknown_accession->_species, undef,'Unknown accession so no species');
is($lookup_unknown_accession->_taxon_id, undef, 'Unknown accession so no taxon ids');
is_deeply($lookup_unknown_accession->_lineage,[], 'Unknown accession so no lineage');
is_deeply($lookup_unknown_accession->_pubmed_ids, [], 'Unknown accession so no pubmed ids');
is($lookup_unknown_accession->_description, undef, 'Unknown accession so no description');

done_testing();
