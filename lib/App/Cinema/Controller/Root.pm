package App::Cinema::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN {
	extends qw/Catalyst::Controller/;
	our $VERSION = $App::Cinema::VERSION;
}

#__PACKAGE__->config->{captcha} = {
#	session_name => 'captcha_string',
#	new          => {
#		width   => 80,
#		height  => 30,
#		lines   => 7,
#		gd_font => 'giant',
#	},
#	create   => [qw/normal rect/],
#	particle => [100],
#	out      => { force => 'jpeg' }
#};

__PACKAGE__->config->{namespace} = '';

sub index : Path : Args(0) {
	my ( $self, $c ) = @_;
	$c->res->redirect( $c->uri_for('/menu/home') );
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
