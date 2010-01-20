package App::Cinema::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub index : Path : Args(0) {
	my ( $self, $c ) = @_;
	$c->res->redirect( $c->uri_for('menu') );
}

sub default : Private {
	my ( $self, $c ) = @_;
	$c->stash->{error}    = "Page not found.";
	$c->stash->{template} = 'result.tt2';
}

sub end : ActionClass('RenderView') {
}

sub auto : Private {
	my ( $self, $c ) = @_;
	$c->stash->{genres} = $c->model('MD::Genre');
}
1;
