package App::Cinema::Controller::Item;
use Moose;
use namespace::autoclean;

BEGIN {
	extends qw/Catalyst::Controller::FormBuilder/;
	our $VERSION = $App::Cinema::VERSION;
}

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

		my $e = App::Cinema::Event->new();
		$e->uid( $row->uid );
		$e->desc(' created movie : ');
		$e->target( $row->title );
		$e->insert($c);

		$c->flash->{message} = 'Created movie : ' . $row->title;
		$c->res->redirect( $c->uri_for('add') );
	}
}

sub detail : Local {
	my ( $self, $c, $id ) = @_;

	#find() returns a row object instead of a recordset
	$c->stash->{item} = $c->model('MD::Item')->find($id);
}

sub view : Local {
	my ( $self, $c ) = @_;
	my $rs = $c->model('MD::Item')->search( $c->session->{query},
		{ order_by => { -desc => 'release_date' } } );
	$c->stash->{items} = $rs;
}

sub delete_do : Local {
	my ( $self, $c, $id, $info ) = @_;
	eval {
		$c->assert_any_user_role(qw/sysadmin admin/);
	};
	if ($@) {
		$c->flash->{error} = $c->config->{need_auth_msg};
		$c->res->redirect( $c->uri_for('/item/view') );
		return;
	}

	$c->model('MD::Item')->find($id)->delete();

	my $e = App::Cinema::Event->new();
	$e->desc(' deleted movie : ');
	$e->target( $info );
	$e->insert($c);

	$c->flash->{message} = "Item deleted";
	$c->res->redirect( $c->uri_for('/item/view') );
}

sub checkout_do : Local {
	my ( $self, $c, $id, $info ) = @_;
	if ( !$c->user_exists ) {
		$c->flash->{error} = $c->config->{need_auth_msg};
		$c->res->redirect( $c->uri_for('/item/view') );
		return 0;
	}

	my $e = App::Cinema::Event->new();
	$e->desc(' watched movie : ');
	$e->target($info);
	$e->insert($c);

	$c->flash->{message} = 'Your checkout "' . $info . '" is completed.';
	$c->res->redirect( $c->uri_for('/item/view') );
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

Jeff Mo - <mo0118@gmail.com>

