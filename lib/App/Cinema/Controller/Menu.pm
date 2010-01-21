package App::Cinema::Controller::Menu;

use strict;
use warnings;
use base 'Catalyst::Controller';

sub index : Private {
	my ( $self, $c ) = @_;
	my $result = $c->model('MD::Item')
	  ->search( undef, { rows => 3, order_by => { -desc => 'release_date' } } );
	$c->stash->{items}    = $result;
	my $news = $c->model('MD::News')
	  ->search( undef, { rows => 3, order_by => { -desc => 'release_date' } } );
	$c->stash->{news}    = $news;
	$c->stash->{template} = "menu.tt2";
}
1;

=head1 NAME

App::Cinema::Controller::Menu - A controller that handles the request for the MENU link.

=head1 SYNOPSIS

You can call its actions in any template files either

    <a HREF="[% Catalyst.uri_for('/menu') %]">MENU</a>
    
or

    <a HREF="[% base %]menu">MENU</a>

You can also use them in any other controller modules like this:

    $c->res->redirect( $c->uri_for('/menu') );
		
=head1 DESCRIPTION

This is a controller that handles the request for the MENU link.

=head2 Methods

=over 12

=item C<index>

This private action is used to retrieve the data of News and Item from database, choose suitable template,
and then propagate to view module.

=back

=head1 AUTHOR

Jeff Mo - L<http://jandc.co.cc/>
