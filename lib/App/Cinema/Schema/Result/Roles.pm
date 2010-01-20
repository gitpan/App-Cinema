package App::Cinema::Schema::Result::Roles;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("roles");
__PACKAGE__->add_columns(
	"id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
	"role",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
	"user_roles",
	"App::Cinema::Schema::Result::UserRoles",
	{ "foreign.role_id" => "self.id" },
);
__PACKAGE__->many_to_many( users => 'user_roles', 'user' );

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-16 23:45:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XQY46wC2jppCFXlBRUM7oA

# You can replace this text with custom content, and it will be preserved on regeneration
1;
