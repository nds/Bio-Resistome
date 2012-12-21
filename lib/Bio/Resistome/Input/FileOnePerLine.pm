package Bio::Resistome::Input::FileOnePerLine;
# ABSTRACT: File containing a list of input data, one per line.

=head1 SYNOPSIS

File containing a list of input data, one per line.

    use Bio::Resistome::Input::FileOnePerLine;
    my $obj = Bio::Resistome::Input::FileOnePerLine->new(
      filename => 'input_file.txt'
    );
    $obj->file_line_data;

=method file_line_data

Returns an array with the input data from the file.

=cut

use Moose;
use Bio::Resistome::Input::Exceptions;

has 'filename'       => ( is => 'ro', isa => 'Str', required => 1 );
has 'file_line_data' => ( is => 'ro', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_file_line_data' );

sub _build_file_line_data
{
  my ($self) = @_;
  
  open(my $fh, $self->filename) or Bio::Resistome::Input::Exceptions::FileDoesntExist->throw(error => 'Couldnt open file '.$self->filename);
  my @file_line_data;
  while(<$fh>)
  {
    chomp;
    my $line = $_;
    next if( $line =~ /^\#/);
    next if( $line eq "");
    push(@file_line_data, $line);
  }
  return \@file_line_data;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
