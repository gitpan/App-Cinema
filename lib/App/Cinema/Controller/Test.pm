package App::Cinema::Controller::Test;
use Moose;
use namespace::autoclean;
#use Mail::Sendmail;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

App::Cinema::Controller::Test - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

#sub index : Path : Args(0) {
#
#	#    my ( $self, $c ) = @_;
#	#
#	#    $c->response->body('Matched App::Cinema::Controller::Test in Test.');
#	my ( $self, $c ) = @_;
#
#	#	sub controller : Private {
#	#		my ( $self, $c ) = @_;
#	#
#	#		$c->stash->{email} = {
#	#			to  => 'mo0118@gmail.com',
#	#			cc  => 'abraxxa@cpan.org',
#	#			bcc => join ',',
#	#			qw/hidden@secret.com hidden2@foobar.com/,
#	#			from    => 'no-reply@foobar.com',
#	#			subject => 'I am a Catalyst generated email',
#	#			body    => 'Body Body Body',
#	#		};
#	#
#	#		$c->forward( $c->view('Email') );
#	#	}
#	my %mail = (
#		To      => 'mo0118@gmail.com',
#		From    => 'me@here.com',
#		Message => "This is a very short message",
#		Smtp    => "susan.asmallorange.com"
#	);
#
#	sendmail(%mail) or die $Mail::Sendmail::error;
#
#	print "OK. Log says:\n", $Mail::Sendmail::log;
#}

#sub controller : Private {
#	my ( $self, $c ) = @_;
#
#	$c->stash->{email} = {
#		to => 'mo0118@gmail.com',
#
#		#cc           => 'abraxxa@cpan.org',
#		#bcc          => 'hidden@secret.com hidden2@foobar.com',
#		from         => 'no-reply@foobar.com',
#		subject      => 'I am a Catalyst generated email',
#		template     => 'test.tt',
#		content_type => 'multipart/alternative'
#	};
#
#	$c->forward( $c->view('Email::Template') );
#}

=head1 AUTHOR

Jeff Mo

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

