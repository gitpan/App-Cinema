package App::Cinema::Controller::Logout;

use strict;
use warnings;
use base qw(Catalyst::Controller);

sub index : Private {
	my ( $self, $c ) = @_;

	# Clear the user's state
	$c->logout;
	$c->flash->{message} = 'Sign out successfully.';

	# Send the user to the starting point
	$c->res->redirect( $c->uri_for('/menu') );
}
1;

=head1 NAME

App::Cinema::Controller::Logout - A controller that handles a request for logout.

=head1 SYNOPSIS

You can call its actions in any template files either

    <a HREF="[% Catalyst.uri_for('/logout') %]">logout</a>
    
or

    <a HREF="[% base %]logout">logout</a>

=head1 DESCRIPTION

This is A controller that handles a request for logout.

=head2 Methods

=over 12

=item C<index>

This private action is used to perform logout action.

=back

=head1 AUTHOR

Jeff Mo - L<http://jandc.co.cc/>