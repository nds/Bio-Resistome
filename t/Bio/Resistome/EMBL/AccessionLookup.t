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
  _full_lookup_url => 't/data/U41471.xml'
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


# Missing lineage
ok my $lookup_missing_lineage = Bio::Resistome::EMBL::AccessionLookup->new(
  accession_number => "U41471",
  _full_lookup_url => 't/data/U41471_missing_lineage.xml'
), 'Initialise missing lineage';
ok($lookup_missing_lineage->accession_metadata, 'build the accession metadata missing lineage');
is($lookup_missing_lineage->_species, 'Mycobacterium fortuitum','Get the species missing lineage');
is($lookup_missing_lineage->_taxon_id, 1766, 'get the taxon id missing lineage');
is_deeply($lookup_missing_lineage->_lineage, [], 'missing lineage');

#  Missing source feature
ok my $lookup_missing_source_feature = Bio::Resistome::EMBL::AccessionLookup->new(
  accession_number => "U41471",
  _full_lookup_url => 't/data/U41471_missing_source_feature.xml'
), 'initialise missing source feature obj';
ok($lookup_missing_source_feature->accession_metadata, 'build the accession metadata missing source feature');
is($lookup_missing_source_feature->_species, undef,'Get the species missing source feature');
is($lookup_missing_source_feature->_taxon_id, undef, 'get the taxon id missing source feature');
is_deeply($lookup_missing_source_feature->_lineage, [], 'missing source feature');


done_testing();
