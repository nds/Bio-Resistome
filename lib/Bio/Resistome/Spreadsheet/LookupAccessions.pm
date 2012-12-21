package Bio::Resistome::Spreadsheet::LookupAccessions;
# ABSTRACT: Create a spreadsheet containing accession lookup results.

=head1 SYNOPSIS

Create a row representation of the accession lookup results.

   use Bio::Resistome::Spreadsheet::LookupAccessions;
   my $spreadsheet_row_obj = Bio::Resistome::Spreadsheet::LookupAccessions->new(
     genes_metadata => $gene_meta_data_obj,
     output_file_name => 'abc'
   );
   $spreadsheet_row_obj->create;

=method create

Create a spreadsheet file of accession lookup results.

=head1 SEE ALSO

=for :list
* L<Bio::Resistome::GeneMetaData>
* L<Bio::Resistome::Spreadsheet::File>

=cut


use Moose;
use Bio::Resistome::Spreadsheet::File;
use Bio::Resistome::Spreadsheet::LookupRow;

has 'genes_metadata'    => ( is => 'ro', isa => 'ArrayRef', required => 1 ); 
has 'output_file_name'  => ( is => 'ro', isa => 'Str',      default => 'output.csv' ); 

sub create
{
  my($self) = @_; 
  
  my @spreadsheet_rows;
  my @spreadsheet_header;
  for my $gene_metadata(@{$self->genes_metadata})
  {
    my $spreadsheet_row_obj = Bio::Resistome::Spreadsheet::LookupRow->new(gene_metadata => $gene_metadata);
    push(@spreadsheet_rows, @{$spreadsheet_row_obj->formatted_row});
    
    if((! @spreadsheet_header ) || @spreadsheet_header < 1)
    {
      @spreadsheet_header = @{$spreadsheet_row_obj->formatted_header};
    }
  }
  
  my $spreadsheet = Bio::Resistome::Spreadsheet::File->new(
    spreadsheet_rows => \@spreadsheet_rows,
    header           => \@spreadsheet_header,
    output_file_name => $self->output_file_name
  );
  $spreadsheet->create();
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
