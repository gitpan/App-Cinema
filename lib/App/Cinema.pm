###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package App::Cinema;
use Moose;
use Catalyst::Runtime '5.70';
use Catalyst qw/
  -Debug
  ConfigLoader
  Static::Simple

  StackTrace

  Authentication
  Authorization::Roles

  Session
  Session::Store::FastMmap
  Session::State::Cookie
  /;

our $VERSION = '1.11';

# Configure the application.
#
# Note that settings in MyApp.yml (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

#__PACKAGE__->config(
#	'Plugin::Authentication' => {
#		default_realm => 'members',
#		realms        => {
#			members => {
#				credential => {
#					class          => 'Password',
#					password_field => 'password',
#					password_type  => 'clear'
#				},
#				store => {
#					class => 'Minimal',
#					users => {
#						bob => {
#							password => "1",
#							editor   => 'yes',
#							roles    => [qw/admin user/],
#						},
#						william => {
#							password => "1",
#							roles    => [qw/user/],
#						}
#					}
#				}
#			}
#		}
#	}
#);
#__PACKAGE__->config(
#	'Plugin::Authentication' => {
#		default_realm => 'members',
#		members       => {
#			credential => {
#				class          => 'Password',
#				password_field => 'password',
#				password_type  => 'clear'
#			},
#			store => {
#				class                => 'DBIx::Class',
#				user_class           => 'MyAppDB::User',
#				role_relation        => 'roles',				
#				role_field           => 'role',
#				role_class           => 'MyAppDB::Role',
#			}
#		}
#	},
#);

# Start the application
__PACKAGE__->setup;

# Authorization::ACL Rules
#__PACKAGE__->deny_access_unless( "/user/delete", [qw/admin/], );

1;
