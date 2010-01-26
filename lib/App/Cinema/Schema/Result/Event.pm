package App::Cinema::Schema::Result::Event;

use Moose;
extends 'DBIx::Class::Core';

#use namespace::alias 'App::Cinema::Schema::Result::Users';
#use App::Cinema::Schema::Result::Users as => 'Users';

#DBIx::Class::Ordered
#__PACKAGE__->load_components(qw/ Ordered /);
#__PACKAGE__->position_column('e_time');
  
__PACKAGE__->table("event");
__PACKAGE__->add_columns(
	"id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
	"uid",
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
	"target",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"e_time",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
	"oneuser",
	"App::Cinema::Schema::Result::Users",
	{ username => "uid" },
);

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-16 23:45:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X5yVF5bMaHRdHj42JA4yPg

# You can replace this text with custom content, and it will be preserved on regeneration
1;
