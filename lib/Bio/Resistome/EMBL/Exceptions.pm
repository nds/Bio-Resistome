package Bio::Resistome::EMBL::Exceptions;

use Exception::Class (
    Bio::Resistome::EMBL::Exceptions::AccessionLookupFailed   => { description => 'Couldnt lookup the accession number metadata' },
);  
use Moose;

__PACKAGE__->meta->make_immutable;

no Moose;
1;
