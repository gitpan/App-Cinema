package App::Cinema::Schema::Result::Genre;

use Moose;
extends 'DBIx::Class';

#use App::Cinema::Schema::Result::GenreItems as => 'GenreItems';

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("genre");
__PACKAGE__->add_columns(
	"id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
	"name",
	{
		data_type     => "VARCHAR",
		default_value => undef,
		is_nullable   => 1,
		size          => 50,
	},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
	"genre_items",
	"App::Cinema::Schema::Result::GenreItems",
	{ "foreign.g_id" => "self.id" },
);
__PACKAGE__->many_to_many( items => 'genre_items', 'item' );

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-16 23:45:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WIFx+rUs/K7PunoHJwjSXg

# You can replace this text with custom content, and it will be preserved on regeneration
1;
