use utf8;
package Bio::Resistome::Database::Result::Reference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Bio::Resistome::Database::Result::Reference

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

=head1 TABLE: C<reference>

=cut

__PACKAGE__->table("reference");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 pubmed

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
  "pubmed",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<pubmed>

=over 4

=item * L</pubmed>

=back

=cut

__PACKAGE__->add_unique_constraint("pubmed", ["pubmed"]);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-21 15:20:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:f+sBXVapa4bYpXq0it/Plg


# ABSTRACT: Schema for a Reference table
1;
