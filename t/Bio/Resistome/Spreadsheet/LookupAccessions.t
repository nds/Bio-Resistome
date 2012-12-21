#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use Bio::Resistome::Accessions;
    use_ok('Bio::Resistome::Spreadsheet::LookupAccessions');
}

# Create gene meta data objects
my $gene_meta_data_obj = Bio::Resistome::Accessions->new(accession_numbers => ['DQ018710', 'unknown_accession','U41471'],_accession_number_lookup_service => 't/data/');

ok((my $spreadsheet_row_obj = Bio::Resistome::Spreadsheet::LookupAccessions->new(
  genes_metadata => $gene_meta_data_obj->accessions_metadata,
  output_file_name => 'test_output_file.csv'
)), 'Initialise valid lookup accessions obj');
ok($spreadsheet_row_obj->create, 'Create the spreadsheet');

compare_files('test_output_file.csv', 't/data/expected_output_file.csv');

unlink('test_output_file.csv');

done_testing();

sub compare_files
{
  my($expected_file, $actual_file) = @_;
  ok((-e $actual_file),  "results file exists  - $actual_file");
  ok((-e $expected_file),"expected file exists - $expected_file");
  local $/ = undef;
  open(EXPECTED, $expected_file);
  open(ACTUAL, $actual_file);
  my $expected_line = <EXPECTED>;
  my $actual_line = <ACTUAL>;
  
  # parallel processes mean the order isnt guaranteed.
  my @split_expected  = split(/\n/,$expected_line);
  my @split_actual  = split(/\n/,$actual_line);
  my @sorted_expected = sort(@split_expected);
  my @sorted_actual  = sort(@split_actual);
  
  is_deeply(\@sorted_expected,\@sorted_actual, "results content matches expected content");
}
