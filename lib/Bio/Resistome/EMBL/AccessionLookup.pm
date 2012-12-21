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
has 'accession_number_lookup_service' => ( is => 'ro', isa => 'Str', default  => 'http://www.ebi.ac.uk/ena/data/view/' );

has 'accession_metadata'              => (is => 'rw', isa => 'Bio::Resistome::GeneMetaData', lazy => 1, builder => '_build_accession_metadata');
has '_full_lookup_url'                => (is => 'rw', isa => 'Str', lazy => 1, builder => '_build__full_lookup_url');

has '_species'    => (is => 'rw', isa => 'Maybe[Str]');
has '_taxon_id'   => (is => 'rw', isa => 'Maybe[Int]');
has '_lineage'    => (is => 'rw', isa => 'ArrayRef', default => sub { [] } );
has '_pubmed_ids' => (is => 'rw', isa => 'ArrayRef', default => sub { [] } );
has '_description' => (is => 'rw', isa => 'Maybe[Str]');

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

sub _populate_description_metadata
{
   my ($self, $tree) = @_;
   return $self if(!(defined($tree->{description})));
   
   if(ref($tree->{description}) && $tree->{description} =~ /ARRAY/)
   {
     Bio::Resistome::EMBL::Exceptions::MoreThanOneDescription->throw(error => "Theres more than 1 description which shouldnt happen for ".$self->accession_number);
   }
   else
   {
     $self->_description($tree->{description});
   }
   return $self;
}

sub _get_pubmed_id
{
  my ($self, $xref) = @_;

  if(defined($xref) && defined($xref->{'-db'}) && $xref->{'-db'} eq 'PUBMED' && defined($xref->{'-id'}) )
  {
    return $xref->{'-id'};
  }
  return undef;
}

sub _populate_reference_metadata
{
  my ($self, $tree) = @_;
  my @pubmed_ids;
  
  if(ref($tree->{reference}) && $tree->{reference} =~ /ARRAY/)
  {
    for my $reference (@{$tree->{reference}})
    {
      next if(! defined($reference->{xref}));
      if( $reference->{xref} =~ /ARRAY/)
      {
        for my $xref (@{$reference->{xref}})
        {
          my $pubmed_id = $self->_get_pubmed_id($xref);
          push(@pubmed_ids,$pubmed_id) if(defined($pubmed_id));
        }  
      }
      else
      {
        my $pubmed_id = $self->_get_pubmed_id($reference->{xref} );
        push(@pubmed_ids,$pubmed_id) if(defined($pubmed_id));
      }
    }
  }
  else
  {
    my $pubmed_id = $self->_get_pubmed_id($tree->{reference});
    push(@pubmed_ids,$pubmed_id) if(defined($pubmed_id));
  }
  
  # Theres a lot more meta data in the referenes section that we dont look at yet, but we might, so this isnt a builder in its own right.
  $self->_pubmed_ids(\@pubmed_ids);

  return $self;
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
        return $self;
      }
    }
  }
  else
  {
    $self->_populate_feature_species_details($tree->{feature});
  }
  return $self;
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
  return $self;
}

sub _parse_xml_and_return_gene_metadata
{
   my ($self, $tree) = @_;

   if(defined($tree) && defined($tree->{ROOT}) && defined($tree->{ROOT}->{entry}) )
   {
     $self->_populate_species_metadata($tree->{ROOT}->{entry});
     $self->_populate_reference_metadata($tree->{ROOT}->{entry});
     $self->_populate_description_metadata($tree->{ROOT}->{entry});
   }

   my $accession_metadata_obj = Bio::Resistome::GeneMetaData->new(
     accession_number => $self->accession_number,
     species          => $self->_species,
     taxon_id         => $self->_taxon_id,
     lineage          => $self->_lineage,
     pubmed_ids       => $self->_pubmed_ids,
     description      => $self->_description,
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
