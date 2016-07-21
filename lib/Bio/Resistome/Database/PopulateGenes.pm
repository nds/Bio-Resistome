package Bio::Resistome::Database::PopulateGenes;
# ABSTRACT: Populate the database using the metadata of multiple genes

=head1 SYNOPSIS

Populate the database using the metadata of multiple genes

    use Bio::Resistome::Database::PopulateGenes;
    my $obj = Bio::Resistome::Database::PopulateGenes->new(
      dbh => $database_handle,
      genes_metadata => []
    );
    $obj->populate;

=method populate

Insert meta data of multiple genes into the database

=head1 SEE ALSO

=for :list
* L<Bio::Resistome::GeneMetaData>
* L<BBio::Resistome::Database::PopulateGene>

=cut

use Moose;
use Bio::Resistome::Database;
use Bio::Resistome::GeneMetaData;

has 'dbh'           => ( is => 'ro', isa => 'Bio::Resistome::Database', required => 1 );
has 'genes_metadata' => ( is => 'ro', isa => 'ArrayRef[Bio::Resistome::GeneMetaData]', required => 1 );

sub populate
{
  my ($self) = @_;
  for my $gene_metadata (@{$self->genes_metadata})
  {
    my $populate_gene = Bio::Resistome::Database::PopulateGene->new(
      dbh => $self->dbh,
      gene_metadata => $gene_metadata
    );
    $populate_gene->populate;
  }
  return 1;
}


__PACKAGE__->meta->make_immutable;

no Moose;

1;
