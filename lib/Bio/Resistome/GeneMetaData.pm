package Bio::Resistome::GeneMetaData;

# ABSTRACT: Datastructure to represent the meta data for a gene

=head1 SYNOPSIS

Take in a reference genome and evolve it.

    use BBio::Resistome::GeneMetaData;
    my $obj = Bio::Resistome::GeneMetaData->new(
       species => 'aaa',
       taxon_id => 123,
       lineage => ['abc','efg','hij']
    );

=head1 SEE ALSO

=for :list
* L<Bio::Resistome::EMBL::AccessionLookup>

=cut

use Moose;

has 'accession_number' => (is => 'ro', isa => 'Str', required => 1);
has 'species'          => (is => 'ro', isa => 'Maybe[Str]');
has 'taxon_id'         => (is => 'ro', isa => 'Maybe[Int]');
has 'lineage'          => (is => 'ro', isa => 'ArrayRef');
has 'pubmed_ids'       => (is => 'ro', isa => 'ArrayRef');


no Moose;
__PACKAGE__->meta->make_immutable;
1;
