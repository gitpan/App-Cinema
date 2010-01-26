package App::Cinema::Schema::Result::News;
use Moose;
use namespace::autoclean;
BEGIN {
	extends 'DBIx::Class';
	our $VERSION = $App::Cinema::VERSION;
}

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("news");
__PACKAGE__->add_columns(
	"id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
	"title",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"desc",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"release_date",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
);
__PACKAGE__->set_primary_key("id");

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-16 23:45:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:W2DZeGniuhNv7CwzDQDx0Q

# You can replace this text with custom content, and it will be preserved on regeneration
1;
