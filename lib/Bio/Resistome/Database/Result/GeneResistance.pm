use utf8;
package Bio::Resistome::Database::Result::GeneResistance;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Bio::Resistome::Database::Result::GeneResistance

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

=head1 TABLE: C<gene_resistance>

=cut

__PACKAGE__->table("gene_resistance");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 gene_id

  data_type: 'integer'
  is_nullable: 1

=head2 resistance_id

  data_type: 'integer'
  is_nullable: 1

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
  { data_type => "integer", is_nullable => 1 },
  "resistance_id",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-21 13:24:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:u2OAMSeZzR3SZwC+1cq/rQ


# ABSTRACT: Schema for a GeneResistance table
1;
