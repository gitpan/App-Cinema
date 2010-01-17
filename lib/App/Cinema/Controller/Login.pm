###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package App::Cinema::Controller::Login;

use strict;
use warnings;
use base 'Catalyst::Controller';

sub index : Private {
	my ( $self, $c ) = @_;

	# Get the username and password from form
	my $username = $c->req->params->{username} || "";
	my $password = $c->req->params->{password} || "";
	#$c->log->debug( 'cmo: username' . $username );

	# If the username and password values were found in form
	if ( $username && $password ) {
		my $status = $c->authenticate(
			{
				username => $username,
				password => $password
			}
		);
		if ($status) {

			#			my $user = $c->model('MD::User')->find($username);
			#			if ( !$user->active ) {
			#				$c->flash->{error} =
			#				  "You account is not activated.";
			#			}
			#			else {

			# If successful, then let them use the application
			$c->flash->{message} = "Welcome back, " . $username;
			$c->res->redirect( $c->uri_for('/menu') );
			return;

			#			}
		}
		else {
			$c->flash->{error} = "Bad username or password.";
		}
	}	
	# If either of above don't work out, send to the login page
	$c->stash->{template} = 'login.tt2';
}

1;
