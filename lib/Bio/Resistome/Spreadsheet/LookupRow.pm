package Bio::Resistome::Spreadsheet::LookupRow;
# ABSTRACT: Create a row representation of the accession lookup results

=head1 SYNOPSIS

Create a row representation of the accession lookup results

   use Bio::Resistome::Spreadsheet::LookupRow;
   my $spreadsheet_row_obj = Bio::Resistome::Spreadsheet::LookupRow->new(
     gene_metadata => $gene_meta_data_obj
   );
   $spreadsheet_row_obj->formatted_row;

=method formatted_row

Returns the spreadsheet row of results, as an array, suitable for outputting to a CSV file.

=method formatted_header

Returns the header columns, as an array, suitable for outputting to a CSV file.

=head1 SEE ALSO

=for :list
* L<Bio::Resistome::GeneMetaData>

=cut


use Moose;
with 'Bio::Resistome::ArrayCommon';

has 'gene_metadata'    => ( is => 'ro', isa => 'Bio::Resistome::GeneMetaData',     required => 1 ); 
has 'formatted_row'    => ( is => 'ro', isa => 'ArrayRef', lazy => 1, builder => '_build_formatted_row'); 
has 'formatted_header' => ( is => 'ro', isa => 'ArrayRef', lazy => 1, builder => '_build_formatted_header'); 

sub _build_formatted_row
{
  my ($self) = @_;

  my @row_cells = [
    $self->gene_metadata->accession_number, 
    $self->gene_metadata->species, 
    $self->gene_metadata->taxon_id,
    $self->gene_metadata->description,
    $self->_comma_separate_array_into_a_single_string($self->gene_metadata->lineage),
    $self->_comma_separate_array_into_a_single_string($self->gene_metadata->pubmed_ids),
  ];

  return \@row_cells;
}

sub _build_formatted_header
{
  my ($self) = @_;
  return ['Accession number', 'Species','TaxonID','Description', 'Lineage','PubMed IDs'];
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
