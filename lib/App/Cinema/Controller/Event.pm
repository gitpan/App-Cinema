package App::Cinema::Controller::Event;

use strict;
use warnings;
use base qw/Catalyst::Controller/;

sub insert {
	my ( $self, $c, $act, $obj ) = @_;
	my $row = $c->model('MD::Event')->create(
		{
			uid    => $c->user->obj->username(),
			desc   => $act,
			target => $obj,
			e_time => HTTP::Date::time2iso(time)
		}
	);
}
1;