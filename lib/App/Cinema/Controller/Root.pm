###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
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

	#	if ( $c->user_exists && $c->req->uri->path eq '/login' ) {
	#		$c->flash->{message} = "Welcome back, " . $c->user->obj->username();
	#		$c->res->redirect( $c->uri_for('/menu') );
	#	}

	#	if (   $c->controller eq $c->controller('Login')
	#		|| $c->req->uri->path eq '/user/add' )
	#	{
	#		return 1;
	#	}

	# If a user doesn't exist, force login
	#	if ( !$c->user_exists ) {

	# Dump a log message to the development server debug output
	#		$c->log->debug('cmo : User not found, forwarding to /login');

	# Redirect the user to the login page
	#		$c->res->redirect( $c->uri_for('/login') );

	#Return 0 to cancel 'post-auto' processing and prevent use of application
	#		return 0;
	#	}

	# User found, so return 1 to continue with processing after this 'auto'
	return 1;
}
1;
