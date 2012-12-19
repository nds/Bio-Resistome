package Bio::Resistome::EMBL::AccessionLookup;
# ABSTRACT: Take in an accession number, lookup EMBL and populate a datastructure

=head1 SYNOPSIS

Take in an accession number, lookup EMBL and populate a datastructure

    use Bio::Resistome::EMBL::AccessionLookup;
    my $obj = Bio::Resistome::EMBL::AccessionLookup->new(
      accession_number => 'ABC'
    );
    $obj->accession_metadata;

=method accession_metadata

Returns a populated Bio::Resistome::GeneMetaData object.

=head1 SEE ALSO

=for :list
* L<Bio::Resistome::GeneMetaData>

=cut

use Moose;
use LWP::UserAgent;
use XML::TreePP;
use URI::Escape;
use Bio::Resistome::EMBL::Exceptions;
use Bio::Resistome::GeneMetaData;

has 'accession_number'                => ( is => 'ro', isa => 'Str', required => 1 );
has 'accession_number_lookup_service' => ( is => 'ro', isa => 'Str', default  => 'http://www.ebi.ac.uk/ena/data/view/U41471&display=xml' );

has 'accession_metadata'              => (is => 'rw', isa => 'Bio::Resistome::GeneMetaData', lazy => 1, builder => '_build_accession_metadata');
has '_full_lookup_url'                => (is => 'rw', isa => 'Str', lazy => 1, builder => '_build__full_lookup_url');

has '_species'    => (is => 'rw', isa => 'Maybe[Str]');
has '_taxon_id'   => (is => 'rw', isa => 'Maybe[Int]');
has '_lineage'    => (is => 'rw', isa => 'ArrayRef', default => sub { [] } );

sub _build__full_lookup_url
{
  my ($self) = @_;
  $self->accession_number_lookup_service.$self->accession_number.'&display=xml';
}

sub _build_accession_metadata
{
  my ($self) = @_;
  my $full_query = $self->_full_lookup_url;
  
  my $accession_metadata_obj = $self->_local_lookup_accession_metadata($full_query);
  unless(defined($accession_metadata_obj))
  {
    $accession_metadata_obj = $self->_remote_lookup_accession_metadata($full_query);
  }
  return $accession_metadata_obj;
}

sub _populate_species_metadata
{
  my ($self, $tree) = @_;
  
  # Can be an array of features or a single feature
  if(ref($tree->{feature}) && $tree->{feature} =~ /ARRAY/)
  {
    for my $feature (@{$tree->{feature}})
    {
      if(defined($feature->{taxon}))
      {
        $self->_populate_feature_species_details($feature);
        return;
      }
    }
  }
  else
  {
    $self->_populate_feature_species_details($tree->{feature});
  }
  return undef;
}

sub _populate_feature_species_details
{
  my ($self, $feature) = @_;
  
  if(defined($feature->{taxon}))
  {

    $self->_species($feature->{taxon}->{'-scientificName'}) if(defined($feature->{taxon}->{'-scientificName'}));
    $self->_taxon_id($feature->{taxon}->{'-taxId'}) if(defined($feature->{taxon}->{'-taxId'}));
    
    if(defined($feature->{taxon}->{lineage}) && defined($feature->{taxon}->{lineage}->{taxon}))
    {
      my @lineages;
      if(ref($feature->{taxon}->{lineage}->{taxon}) && $feature->{taxon}->{lineage}->{taxon} =~ /ARRAY/)
      {
        for my $lineage (@{$feature->{taxon}->{lineage}->{taxon}})
        {
          push(@lineages, $lineage->{'-scientificName'}) if(defined($lineage->{'-scientificName'}));
        }
        $self->_lineage(\@lineages);
      }
    }
  }
  return undef;
}

sub _parse_xml_and_return_gene_metadata
{
   my ($self, $tree) = @_;

   $self->_populate_species_metadata($tree->{ROOT}->{entry});
   
   my $accession_metadata_obj = Bio::Resistome::GeneMetaData->new(
     accession_number => $self->accession_number,
     species  => $self->_species,
     taxon_id => $self->_taxon_id,
     lineage  => $self->_lineage,
   );
   
   return $accession_metadata_obj;
}


sub _local_lookup_accession_metadata
{
  my ($self, $file) = @_;
  return undef unless (-e $file);
  
  my $tpp = XML::TreePP->new();
  my $tree = $tpp->parsefile( $file );
  return $self->_parse_xml_and_return_gene_metadata($tree);
}

sub _remote_lookup_accession_metadata
{
  my ($self, $url) = @_;
  
  eval {
    my $tpp = $self->_setup_xml_parser_via_proxy;
    my $tree = $tpp->parsehttp( GET => $url );
    return $self->_parse_xml_and_return_gene_metadata($tree);
  } or do
  {
     Bio::Resistome::EMBL::Exceptions::AccessionLookupFailed->throw( error => "Cant lookup accession number ".$self->accession_number );
  };
}

sub _setup_xml_parser_via_proxy
{
  my ($self) = @_;
  my $tpp = XML::TreePP->new();
  my $ua = LWP::UserAgent->new();
  $ua->timeout( 60 );
  $ua->env_proxy;
  $tpp->set( lwp_useragent => $ua );
  $tpp;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
