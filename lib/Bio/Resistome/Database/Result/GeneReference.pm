use utf8;
package Bio::Resistome::Database::Result::GeneReference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Bio::Resistome::Database::Result::GeneReference

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<gene_reference>

=cut

__PACKAGE__->table("gene_reference");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  is_nullable: 0

=head2 reference_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "gene_id",
  { data_type => "integer", is_nullable => 0 },
  "reference_id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-21 13:24:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:un+CcQjwReGOohkM/Z5V5Q


# ABSTRACT: Schema for a GeneReference table
1;
