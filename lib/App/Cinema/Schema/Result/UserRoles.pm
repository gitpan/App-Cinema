package App::Cinema::Schema::Result::UserRoles;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("user_roles");
__PACKAGE__->add_columns(
	"user_id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"role_id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
);
__PACKAGE__->set_primary_key( "user_id", "role_id" );
__PACKAGE__->belongs_to(
	"user",
	"App::Cinema::Schema::Result::Users",
	{ username => "user_id" },
);
__PACKAGE__->belongs_to(
	"role",
	"App::Cinema::Schema::Result::Roles",
	{ id => "role_id" },
);

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-16 23:45:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GJkhAN3c8VRWaJfRDFe6Pw

# You can replace this text with custom content, and it will be preserved on regeneration
1;
