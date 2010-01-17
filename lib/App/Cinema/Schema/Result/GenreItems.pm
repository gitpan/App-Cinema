package App::Cinema::Schema::Result::GenreItems;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("genre_items");
__PACKAGE__->add_columns(
  "g_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "i_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("g_id", "i_id");
__PACKAGE__->belongs_to("item", "App::Cinema::Schema::Result::Item", { id => "i_id" });
__PACKAGE__->belongs_to("genre", "App::Cinema::Schema::Result::Genre", { id => "g_id" });


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-16 23:45:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3umT1H9AaNApB1PEZEP2kw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
