#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use_ok('Bio::Resistome::Input::FileOnePerLine');
}

ok((my $obj = Bio::Resistome::Input::FileOnePerLine->new(filename => 't/data/file_of_accessions.txt')), 'Initialise input parser');
is_deeply($obj->file_line_data, 
  [
    'AAAA',
    'BBBB',
    'CCCCCC',
    'DDDD_123'
  ], 'Correct data returned');


throws_ok(sub {Bio::Resistome::Input::FileOnePerLine->new(filename => 'file_which_doesnt_exist.txt')->file_line_data}, qr/Couldnt open file/, 'Initialise file which doesnt exist');


done_testing();
