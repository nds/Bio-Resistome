#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use_ok('Bio::Resistome::Accessions');
}

my @accession_numbers = ['DQ018710', 'unknown_accession','U41471'];

ok my $obj = Bio::Resistome::Accessions->new(
  accession_numbers => @accession_numbers,
  _accession_number_lookup_service => 't/data/'
), 'initialise accessions metadata';
ok($obj->accessions_metadata, 'get accessions metadata');


is_deeply(
  [
    $obj->accessions_metadata->[0]->taxon_id,
    $obj->accessions_metadata->[1]->taxon_id,
    $obj->accessions_metadata->[2]->taxon_id
  ],
  [
    49283,
    undef,
    1766
  ],
  'Check taxon ids are as expected');

is_deeply(
  [
    $obj->accessions_metadata->[0]->species,
    $obj->accessions_metadata->[1]->species,
    $obj->accessions_metadata->[2]->species
  ],
  [
    'Paenibacillus thiaminolyticus',
    undef,
    'Mycobacterium fortuitum'
  ],
  'Check species are as expected');



is_deeply(
  [
    $obj->accessions_metadata->[0]->lineage,
    $obj->accessions_metadata->[1]->lineage,
    $obj->accessions_metadata->[2]->lineage
  ],
  [
    [
      'Bacteria',
      'Firmicutes',
      'Bacilli',
      'Bacillales',
      'Paenibacillaceae',
      'Paenibacillus'
    ],
    [],
    [
      'Bacteria',
      'Actinobacteria',
      'Actinobacteridae',
      'Actinomycetales',
      'Corynebacterineae',
      'Mycobacteriaceae',
      'Mycobacterium'
    ]
  ],
  'Check lineage are as expected');
  
is_deeply(
  [
    $obj->accessions_metadata->[0]->pubmed_ids,
    $obj->accessions_metadata->[1]->pubmed_ids,
    $obj->accessions_metadata->[2]->pubmed_ids
  ],
  [
    ['16189102'],
    [],
    ['8891143']
  ],
  'Check pubmed_ids are as expected');   

is_deeply(
  [
    $obj->accessions_metadata->[0]->description,
    $obj->accessions_metadata->[1]->description,
    $obj->accessions_metadata->[2]->description
  ],
  [
    'Paenibacillus thiaminolyticus strain PT-2B1 putative transposase and putative GNAT family acetyltransferase genes, complete cds; and glycopeptide resistance vanA operon, partial sequence.',
    undef,
    "Mycobacterium fortuitum aminoglycoside 2'-N-acetyltransferase (aac(2')-Ib) gene, complete cds."
  ],
  'Check descriptions are as expected');

is_deeply(
  [
    $obj->accessions_metadata->[0]->accession_number,
    $obj->accessions_metadata->[1]->accession_number,
    $obj->accessions_metadata->[2]->accession_number
  ],
  [
    'DQ018710',
    'unknown_accession',
    'U41471'
  ],
  'Check accession numbers are as expected');



done_testing();