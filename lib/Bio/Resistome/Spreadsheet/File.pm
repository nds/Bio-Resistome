package Bio::Resistome::Spreadsheet::File;
# ABSTRACT: Create a spreadsheet file of results

=head1 SYNOPSIS

Create a spreadsheet file of results

   use Bio::Resistome::Spreadsheet::File;
   my $spreadsheet = Bio::Resistome::Spreadsheet::File->new(
     spreadsheet_rows => [],
     header => []
   );
   $spreadsheet->create();

=method create

Create a spreadsheet file of results.

=head1 SEE ALSO

=for :list
* L<Bio::MLST::Spreadsheet::Row>

=cut

use Moose;
use Text::CSV;

has 'spreadsheet_rows'  => ( is => 'ro', isa => 'ArrayRef', required => 1 );  
has 'header'            => ( is => 'ro', isa => 'ArrayRef', required => 1 ); 
has 'output_file_name'  => ( is => 'ro', isa => 'Str',      default => 'output.csv' ); 

sub create
{
  my($self) = @_;

  open(my $output_fh,'+>', $self->output_file_name);
  
  my $csv_obj = Text::CSV->new();
  $csv_obj->eol ("\r\n");
  $csv_obj->sep_char("\t");

  $csv_obj->print ($output_fh, $_) for $self->header;
  
  for my $row (@{$self->spreadsheet_rows})
  {
    $csv_obj->print ($output_fh, $_) for $row;
  }

  close($output_fh);
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
