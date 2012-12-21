package Bio::Resistome::Input::Exceptions;
# ABSTRACT: Exceptions for input data 

=head1 SYNOPSIS

Exceptions for input data 

=cut


use Exception::Class (
    Bio::Resistome::Input::Exceptions::FileDoesntExist   => { description => 'Couldnt open the file' },
);  
use Moose;

__PACKAGE__->meta->make_immutable;

no Moose;
1;
