#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use DBICx::TestDatabase;
    use Bio::Resistome::Database;
    use Bio::Resistome::EMBL::AccessionLookup;
    use_ok('Bio::Resistome::Database::PopulateGene');
}

# setup test databases with seed data
my $dbh = DBICx::TestDatabase->new('Bio::Resistome::Database');

# create some test gene metadata
my $gene_meta_data_obj = Bio::Resistome::EMBL::AccessionLookup->new(accession_number => "U41471",_full_lookup_url => 't/data/U41471&display=xml')->accession_metadata;
$gene_meta_data_obj->resistance_classes(['beta-lactamase']);
$gene_meta_data_obj->name('gene_name');


# Add a gene where there is no data in the database
ok((my $first_obj = Bio::Resistome::Database::PopulateGene->new(
  dbh => $dbh,
  gene_metadata => $gene_meta_data_obj
)),'Initialise adding a gene where there is no data in the database');
ok(($first_obj->populate),'Populate the database');

my $reference_row = $dbh->resultset('Reference')->search({ pubmed => '8891143' })->first();
ok(defined($reference_row),'Reference pubmed exists');
my $non_existant_reference_row = $dbh->resultset('Reference')->search({ pubmed => '9999999999' })->first();
ok((!defined($non_existant_reference_row)),'Reference pubmed doesnt exist');

my $resistance_class_row = $dbh->resultset('ResistanceClass')->search({ name => 'beta-lactamase' })->first();
ok(defined($resistance_class_row),'Resistance class exists');
my $non_existant_resistance_class_row = $dbh->resultset('ResistanceClass')->search({ name => 'nonexistant resistant class' })->first();
ok((!defined($non_existant_resistance_class_row)),'Resistance class doesnt exist');

# Add the gene again, the species, resistance class and reference tables shouldnt update, but there should be a new gene row.


# check where the resistance class isnt populated.


done_testing();