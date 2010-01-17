###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package App::Cinema::Controller::Item;

use strict;
use warnings;
use base qw/Catalyst::Controller::FormBuilder/;

sub add : Local Form {
	my ( $self, $c ) = @_;
	my $form = $self->formbuilder;

	$form->field(
		name => 'genre',
		options =>
		  [ map { [ $_->id, $_->name ] } $c->model('MD::Genre')->all ]
	);

	if ( $form->submitted && $form->validate ) {
		my $row = $c->model('MD::Item')->create(
			{
				title        => $form->field('title'),
				plot         => $form->field('plot'),
				year         => $form->field('year'),
				img          => $form->field('img'),
				release_date => HTTP::Date::time2iso(time),
				genre_items  => [ { g_id => $form->field('genre') }, ],
				uid          => $c->user->obj->username()
			}
		);
		my $result = $c->model('MD::Event')->create(
			{
				uid    => $c->user->obj->username(),
				desc   => ' created movie : ',
				target => $row->title,
				e_time => HTTP::Date::time2iso(time)
			}
		);
		$c->flash->{message} = 'Created movie : ' . $row->title;
		$c->res->redirect( $c->uri_for('add') );
	}
}

sub detail : Local {
	my ( $self, $c, $id ) = @_;
	$c->stash->{item} = $c->model('MD::Item')->find($id);
}

#do search stuff; only used by clicking search button
sub search_do : Local {
	my ( $self, $c ) = @_;
	my $genre  = $c->req->params->{sel};
	my $string = $c->req->params->{txt};
	my $str    = $c->req->params->{'txt'};
	$c->session->{query}  = $str;
	$c->session->{genre}  = $genre;
	$c->session->{string} = $string;
	$c->res->redirect( $c->uri_for('search') );
}

#display only; reused by checkout and delete action
sub search : Local {
	my ( $self, $c ) = @_;
	my $genre = $c->session->{genre};
	my @fields = qw/title/;
	my @tokens = $c->session->{'query'};
	@fields = cross( \@fields, \@tokens );

	my $rs = $c->model('MD::Item')
	     ->search( \@fields, { rows => 10,, order_by => { -desc => 'release_date' } } );

	#	my $result;
	#	if ($genre) {
	#		$result = $c->model('MD::Genre')->search( { id => $genre } );
	#	}
	#	else {
	#		$result = $c->model('MD::Genre');
	#
	#		#->search( undef, { rows => 10, order_by => 'release_date' } );
	#	}
	$c->stash->{items} = $rs;
}

sub cross {
	my $columns = shift || [];
	my $tokens  = shift || [];
	map { s/%/\\%/g } @$tokens;
	my @result;
	foreach my $column (@$columns) {
		push @result, ( map +{ $column => { -like => "%$_%" } }, @$tokens );
	}
	return @result;
}

sub delete_do : Local {
	my ( $self, $c, $id, $info ) = @_;
	if ( $c->check_user_roles(qw/admin/) ) {
		$c->model('MD::Item')->find($id)->delete();
		my $result = $c->model('MD::Event')->create(
			{
				uid    => $c->user->obj->username(),
				desc   => ' deleted movie : ',
				target => $info,
				e_time => HTTP::Date::time2iso(time)
			}
		);
		$c->flash->{message} = "Item deleted";
	}
	else {
		$c->flash->{error} = "You are not authorized to delete this.";
	}
	$c->res->redirect( $c->uri_for('search') );
}

sub checkout_do : Local {
	my ( $self, $c, $id, $info ) = @_;
	if ( !$c->user_exists ) {
		$c->flash->{error} = "You need to log in first to use this function.";
		$c->res->redirect( $c->uri_for('search') );
		return 0;
	}
	my $row = $c->model('MD::Event')->create(
		{
			uid    => $c->user->obj->username(),
			desc   => ' watched movie : ',
			target => $info,
			e_time => HTTP::Date::time2iso(time)
		}
	);
	if ($row) {
		$c->flash->{message} = 'Your checkout "' . $info . '" is completed.';
	}
	else {
		$c->flash->{message} = 'Your checkout "' . $info . '" is failed.';
	}
	$c->res->redirect( $c->uri_for('search') );
}

1;
