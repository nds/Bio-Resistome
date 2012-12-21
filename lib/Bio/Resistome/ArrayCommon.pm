package Bio::Resistome::ArrayCommon;
# ABSTRACT: Moose role for common array manipulation functions

=head1 SYNOPSIS

Moose role for common array manipulation functions

   with 'Bio::Resistome::ArrayCommon';

=head1 SEE ALSO

=for :list
* L<Bio::Resistome::Spreadsheet::LookupRow>
* L<Bio::MLST::Download::Databases>

=cut

use Moose::Role;

sub _comma_separate_array_into_a_single_string
{
  my ($self,$input_array) = @_;
  return join(',',@{$input_array});
}

no Moose;
1;

