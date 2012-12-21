package Bio::Resistome::EMBL::Exceptions;
# ABSTRACT: Exceptions for EMBL

=head1 SYNOPSIS

Exceptions for EMBL

=cut

use Exception::Class (
    Bio::Resistome::EMBL::Exceptions::AccessionLookupFailed   => { description => 'Couldnt lookup the accession number metadata' },
    Bio::Resistome::EMBL::Exceptions::MoreThanOneDescription   => { description => 'Theres more than 1 description for an entry, shouldnt happen' },
);  
use Moose;

__PACKAGE__->meta->make_immutable;

no Moose;
1;
