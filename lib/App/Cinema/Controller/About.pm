package App::Cinema::Controller::About;

use strict;
use warnings;
use base qw(Catalyst::Controller);

sub index : Private {
	my ( $self, $c ) = @_;
	$c->stash->{template} = "about.tt2";
}
1;

=head1 NAME

App::Cinema::Controller::About - A controller that handles a request for 'About' page.

=head1 SYNOPSIS

You can call its actions in any template files either

    <a HREF="[% Catalyst.uri_for('/about') %]">ABOUT</a>
    
or

    <a HREF="[% base %]about">ABOUT</a>

=head1 DESCRIPTION

This is A controller that handles a request for About page.

=head2 Methods

=over 12

=item C<index>

This private action is used to display 'ABOUT' page.

=back

=head1 AUTHOR

Jeff Mo - L<http://jandc.co.cc/>
