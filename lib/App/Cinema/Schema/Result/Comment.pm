package App::Cinema::Schema::Result::Comment;

use Moose;
use namespace::autoclean;
BEGIN {
	extends 'DBIx::Class';
	our $VERSION = $App::Cinema::VERSION;
}

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("comment");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "uid",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "desc",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "e_time",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to("oneuser", "App::Cinema::Schema::Result::Users", { username => "uid" });


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-27 12:17:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZSbPRuD41jc+XNC3SpmsrQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
