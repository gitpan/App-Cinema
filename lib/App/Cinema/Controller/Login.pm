package App::Cinema::Controller::Login;

use strict;
use warnings;
use base 'Catalyst::Controller';

sub index : Private {
	my ( $self, $c ) = @_;

	# Get the username and password from form
	my $username = $c->req->params->{username} || "";
	my $password = $c->req->params->{password} || "";

	# If the username and password values were found in form
	if ( $username && $password ) {
		my $status = $c->authenticate(
			{
				username => $username,
				password => $password
			}
		);
		if ($status) {

			# If successful, then let them use the application
			$c->flash->{message} = "Welcome back, " . $username;
			$c->res->redirect( $c->uri_for('/menu') );
			return;
		}
		else {
			$c->flash->{error} = "Bad username or password.";
		}
	}

	# If either of above don't work out, send to the login page
	$c->stash->{template} = 'login.tt2';
}

1;

=head1 NAME

App::Cinema::Controller::Login - A controller that handles a request for login.

=head1 SYNOPSIS

You can call its actions in any template files either

    <a HREF="[% Catalyst.uri_for('/login') %]">login</a>
    
or

    <a HREF="[% base %]login">login</a>

=head1 DESCRIPTION

This is A controller that handles a request for login.

=head2 Methods

=over 12

=item C<index>

This private action is used to perform login action.

=back

=head1 AUTHOR

Jeff Mo - L<http://jandc.co.cc/>
