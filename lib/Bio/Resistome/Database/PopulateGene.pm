package Bio::Resistome::Database::PopulateGene;
# ABSTRACT: Populate the database using gene meta data

=head1 SYNOPSIS

Populate the database using gene meta data.

    use Bio::Resistome::Database::PopulateGene;
    my $obj = Bio::Resistome::Database::PopulateGene->new(
      dbh => $database_handle,
      gene_metadata => $gene_metadata_obj
    );
    $obj->populate;

=method populate

Insert gene data into the database.

=head1 SEE ALSO

=for :list
* L<Bio::Resistome::GeneMetaData>

=cut

use Moose;
use Bio::Resistome::Database;

with 'Bio::Resistome::ArrayCommon';

has 'dbh'           => ( is => 'ro', isa => 'Bio::Resistome::Database',     required => 1 );
has 'gene_metadata' => ( is => 'ro', isa => 'Bio::Resistome::GeneMetaData', required => 1 );

sub _find_or_create_species
{
  my ($self,$name) = @_;
  
  my $species_row = $self->dbh->resultset('Species')->find_or_create({
    name     => $self->gene_metadata->species,
    taxon_id => $self->gene_metadata->taxon_id,
    lineage  => $self->_comma_separate_array_into_a_single_string($self->gene_metadata->lineage),
  });
  return $species_row->id;
}

sub _find_or_create_reference
{
  my ($self) = @_;
  
  my @reference_db_row_ids;
  for my $pubmed_id (@{$self->gene_metadata->pubmed_ids})
  {
    my $reference_row = $self->dbh->resultset('Reference')->find_or_create({
      pubmed     => $pubmed_id,
    });
    push(@reference_db_row_ids, $reference_row->id);
  }
  return \@reference_db_row_ids;
}

sub _find_or_create_resistance_class
{
  my ($self) = @_;
  
  my @resistance_classes_row_ids;
  for my $resistance_class_name (@{$self->gene_metadata->resistance_classes})
  {
     my $resistance_class_row = $self->dbh->resultset('ResistanceClass')->find_or_create({
        name     => $resistance_class_name,
      });
     push(@resistance_classes_row_ids, $resistance_class_row->id);
  }
  return \@resistance_classes_row_ids;
}

sub _create_gene
{
  my ($self) = @_;
  
  my $gene_row = $self->dbh->resultset('Gene')->create({
   name        => $self->gene_metadata->name,
   description => $self->gene_metadata->description,
   species_id  => $self->_find_or_create_species,
   accession   => $self->gene_metadata->accession_number,
  });
  return $gene_row->id;
}

sub _find_or_create_gene_reference
{
  my ($self,$gene_row_id, $reference_row_ids) = @_;
  
  for my $reference_row_id (@{$reference_row_ids})
  {

    
    $self->dbh->resultset('GeneReference')->find_or_create({
        gene_id      => $gene_row_id,
        reference_id => $reference_row_id,
      });
  }
  return 1;
}

sub _find_or_create_gene_resistance
{
  my ($self,$gene_row_id, $resistance_class_row_ids) = @_;
  for my $resistance_class_row_id (@{$resistance_class_row_ids})
  {
    $self->dbh->resultset('GeneResistance')->find_or_create({
        gene_id       => $gene_row_id,
        resistance_id => $resistance_class_row_id,
      });
  }
  return 1;
}

sub populate
{
  my ($self) = @_;
  
  my $gene_row_id = $self->_create_gene;
  
  # create the atomic rows in other tables
  my $reference_row_ids = $self->_find_or_create_reference;
  my $resistance_classes_row_ids = $self->_find_or_create_resistance_class;
  
  # create the link rows
  $self->_find_or_create_gene_reference($gene_row_id,$reference_row_ids);
  $self->_find_or_create_gene_resistance($gene_row_id,$resistance_classes_row_ids);
}


__PACKAGE__->meta->make_immutable;
no Moose;
1;
