package App::Cinema::Schema::Result::Event;
use Moose;
use namespace::autoclean;
BEGIN {
	extends 'DBIx::Class';
	our $VERSION = $App::Cinema::VERSION;
}

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("event");
__PACKAGE__->add_columns(
	"id",
	{
		data_type     => "INT",
		default_value => undef,
		is_nullable   => 0,
		size          => 11
	},
	"uid",
	{
		data_type     => "VARCHAR",
		default_value => undef,
		is_nullable   => 1,
		size          => 20,
	},
	"content",
	{
		data_type     => "VARCHAR",
		default_value => undef,
		is_nullable   => 1,
		size          => 20,
	},
	"target",
	{
		data_type     => "VARCHAR",
		default_value => undef,
		is_nullable   => 1,
		size          => 20,
	},
	"e_time",
	{
		data_type     => "VARCHAR",
		default_value => undef,
		is_nullable   => 1,
		size          => 20,
	},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
	"oneuser",
	"App::Cinema::Schema::Result::Users",
	{ username => "uid" },
);

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-29 22:05:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:byEeQvREDtUsDeDZyKxUcg

# You can replace this text with custom content, and it will be preserved on regeneration
1;
