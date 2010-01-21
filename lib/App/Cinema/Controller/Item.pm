package App::Cinema::Controller::Item;

use strict;
use warnings;
use base qw/Catalyst::Controller::FormBuilder/;

sub add : Local Form {
	my ( $self, $c ) = @_;
	my $form = $self->formbuilder;

	$form->field(
		name    => 'genre',
		options => [ map { [ $_->id, $_->name ] } $c->model('MD::Genre')->all ]
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
	my $genre  = $c->session->{genre};
	my @fields = qw/title/;
	my @tokens = $c->session->{'query'};
	@fields = cross( \@fields, \@tokens );
	my $rs =
	  $c->model('MD::Item')
	  ->search( \@fields,
		{ rows => 10,, order_by => { -desc => 'release_date' } } );

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

=head1 NAME

App::Cinema::Controller::Item - A controller that handles the 
movie item's actions.

=head1 SYNOPSIS

You can call its actions in any template files either

    <form action="[% Catalyst.uri_for('/item/search_do') %]" method="POST">
    
or

    <form action="[% base %]item/search_do" method="POST">

You can also use them in any other controller modules like this:

    $c->res->redirect( $c->uri_for('search') );
		
=head1 DESCRIPTION

This is a controller that will handle every action of a movie item.

=head2 Methods

=over 12

=item C<add>

This action is used to add an item.

=item C<checkout_do>

This action is used to checkout an item.

=item C<delete_do>

This action is used to delete an item.

=item C<detail>

This action is used to display the detail of an item.

=item C<search>

This action is used to display the result of item search. 

=item C<search_do>

This action is used to search items with or without condition.

=back

=head1 AUTHOR

Jeff Mo - L<http://jandc.co.cc/>

