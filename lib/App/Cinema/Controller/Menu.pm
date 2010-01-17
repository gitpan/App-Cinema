###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package App::Cinema::Controller::Menu;

use strict;
use warnings;
use base 'Catalyst::Controller';

sub index : Private {
	my ( $self, $c ) = @_;

	my $result =
	  $c->model('MD::Item')
	  ->search( undef, { rows => 3, order_by => { -desc => 'release_date' } } );
	$c->stash->{items}    = $result;
	$c->stash->{template} = "menu.tt2";
}
1;
