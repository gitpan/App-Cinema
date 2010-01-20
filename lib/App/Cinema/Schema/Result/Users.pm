package App::Cinema::Schema::Result::Users;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
	"username",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
	"password",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"email_address",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"first_name",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"last_name",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"active",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
);
__PACKAGE__->set_primary_key("username");
__PACKAGE__->has_many(
	"events",
	"App::Cinema::Schema::Result::Event",
	{ "foreign.uid" => "self.username" },
);
__PACKAGE__->has_many(
	"user_roles",
	"App::Cinema::Schema::Result::UserRoles",
	{ "foreign.user_id" => "self.username" },
);
__PACKAGE__->has_many(
	"items",
	"App::Cinema::Schema::Result::Item",
	{ "foreign.uid" => "self.username" },
);

#roles : field name of User
__PACKAGE__->many_to_many( roles => 'user_roles', 'role' );

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-16 23:45:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:guTR7dmBq9bIQAVUhmgzYQ

# You can replace this text with custom content, and it will be preserved on regeneration
1;
