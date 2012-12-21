package Bio::Resistome::Accessions;
# ABSTRACT: Take in a list of accession numbers and extract the gene metadata

=head1 SYNOPSIS

Take in a list of accession numbers and extract the gene metadata

    use Bio::Resistome::AccessionLookup;
    my $obj = Bio::Resistome::Accessions->new(
      accession_numbers => 'ABC'
    );
    $obj->accessions_metadata;

=method accessions_metadata

Returns an array of populated Bio::Resistome::GeneMetaData objects.

=head1 SEE ALSO

=for :list
* L<Bio::Resistome::EMBL::AccessionLookup>

=cut

use Moose;
use Bio::Resistome::EMBL::AccessionLookup;

has 'accession_numbers'    => ( is => 'ro', isa => 'ArrayRef[Str]', required => 1 );
has 'accessions_metadata'  => ( is => 'ro', isa => 'ArrayRef[Bio::Resistome::GeneMetaData]', lazy => 1, builder => '_build_accessions_metadata');

has '_accession_number_lookup_service' => ( is => 'ro', isa => 'Str', default  => 'http://www.ebi.ac.uk/ena/data/view/' );

sub _build_accessions_metadata
{
  my ($self) = @_;
 
  my @accession_numbers;
  for my $accession (@{$self->accession_numbers})
  {
    my $accession_lookup = Bio::Resistome::EMBL::AccessionLookup->new(
     accession_number => $accession,
     accession_number_lookup_service => $self->_accession_number_lookup_service
    );
    push( @accession_numbers, $accession_lookup->accession_metadata);
  }
  return \@accession_numbers;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
