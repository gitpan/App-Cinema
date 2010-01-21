package App::Cinema::Controller::User;

use strict;
use warnings;
use HTTP::Date;
use base qw(Catalyst::Controller::FormBuilder);

sub history : Local {
	my ( $self, $c ) = @_;
	if ( !$c->user_exists ) {
		$c->stash->{error} = "You need to log in first to use this function.";
		$c->stash->{template} = 'result.tt2';
		return 0;
	}
	my $rs;
	if ( $c->check_user_roles(qw/admin/) ) {
		$rs =
		  $c->model('MD::Event')
		  ->search( undef, { rows => 10, order_by => { -desc => 'e_time' } } );
	}
	else {
		$rs =
		  $c->model('MD::Event')->search( { uid => $c->user->obj->username() },
			{ rows => 10, order_by => { -desc => 'e_time' } } );
	}

	#page navigation
	my $page = $c->req->param('page');
	$page               = 1 if ( $page !~ /^\d+$/ );
	$rs                 = $rs->page($page);
	$c->stash->{pager}  = $rs->pager();
	$c->stash->{events} = $rs;
}

sub add : Local Form {
	my ( $self, $c ) = @_;
	my $form = $self->formbuilder;
	$form->field(
		name     => 'role',
		required => 1,
		options  => [ map { [ $_->id, $_->role ] } $c->model('MD::Roles')->all ]
	);
	if ( $form->submitted && $form->validate ) {
		my $row = $c->model('MD::User')->create(
			{
				first_name    => $form->field('fname'),
				last_name     => $form->field('lname'),
				email_address => $form->field('email'),
				username      => $form->field('uid'),
				password      => $form->field('pwd'),
				active        => 1,
				user_roles    => [ { role_id => $form->field('role') }, ],
			}
		);
		my $result = $c->model('MD::Event')->create(
			{
				uid    => $row->username,
				desc   => ' created account : ',
				target => $row->username,
				e_time => HTTP::Date::time2iso(time)
			}
		);
		$c->flash->{message} = 'Added ' . $row->first_name;
		$c->res->redirect( $c->uri_for('/login') );
	}
}

sub active : Local {
	my ( $self, $c, $arg, $id ) = @_;

	#my $form = $self->formbuilder;
	#if ( $form->submitted && $form->validate ) {
	my $user = $c->model('MD::User')->find( { username => $id } );
	$user->active($arg);
	$user->update_or_insert();
	my $status = $arg ? ' activated ' : ' deactivated ';
	my $result = $c->model('MD::Event')->create(
		{
			uid    => $c->user->obj->username(),
			desc   => $status . '  account : ',
			target => $id,
			e_time => HTTP::Date::time2iso(time)
		}
	);
	$c->flash->{message} = 'Success!';
	$c->response->redirect( $c->uri_for('/user/view') );

	#}
}

sub edit : Local Form {
	my ( $self, $c, $id ) = @_;
	my $form = $self->formbuilder;
	my $user = $c->model('MD::Users')->find( { username => $id } );
	if ( $form->submitted && $form->validate ) {
		$user->first_name( $form->field('fname') );
		$user->last_name( $form->field('lname') );
		$user->email_address( $form->field('email') );
		$user->password( $form->field('pwd') );
		$user->update_or_insert();

		#write to event db
		my $result = $c->model('MD::Event')->create(
			{
				uid    => $c->user->obj->username(),
				desc   => ' edited account : ',
				target => $id,
				e_time => HTTP::Date::time2iso(time)
			}
		);
		$c->flash->{message} = 'Edited ' . $user->first_name;
		$c->response->redirect( $c->uri_for('/menu') );
	}
	else {
		$form->field(
			name  => 'fname',
			value => $user->first_name
		);
		$form->field(
			name  => 'lname',
			value => $user->last_name
		);
		$form->field(
			name  => 'email',
			value => $user->email_address
		);
		$form->field(
			name  => 'pwd',
			value => $user->password
		);
	}
}

sub view : Local {
	my ( $self, $c, $uid ) = @_;
	if ( !$c->user_exists ) {
		$c->stash->{error} = "You need to log in first to use this function.";
		$c->stash->{template} = 'result.tt2';
		return 0;
	}
	if ( $c->check_user_roles(qw/admin/) ) {
		$c->stash->{users} = $c->model('MD::Users');
	}
	else {
		$c->stash->{users} =
		  $c->model('MD::Users')
		  ->search( { username => $c->user->obj->username() } );
	}
}

sub delete_do : Local {
	my ( $self, $c, $id ) = @_;
	if ( $c->check_user_roles(qw/admin/) ) {
		$c->model('MD::Users')->find($id)->delete();
		my $result = $c->model('MD::Event')->create(
			{
				uid    => $c->user->obj->username(),
				desc   => ' deleted account : ',
				target => $id,
				e_time => HTTP::Date::time2iso(time)
			}
		);
		$c->flash->{message} = "User deleted";
	}
	else {
		$c->flash->{error} = "You are not authorized to delete this.";
	}
	$c->res->redirect( $c->uri_for('/user/view') );
}

#sub test : Local {
#	my ( $self, $c, $arg1, $arg2 ) = @_;
#	my $result = $c->model('MD::Event')->create(
#		{
#			uid    => $c->user->obj->username(),
#			desc   => $arg1,
#			target => $arg2,
#			e_time => HTTP::Date::time2iso(time)
#		}
#	);
#}

1;

=head1 NAME

App::Cinema::Controller::User - A controller that handles a user's actions.

=head1 SYNOPSIS

You can call its actions in any template files either

    <a HREF="[% Catalyst.uri_for('/user/add') %]">Admin</a>
    
or

    <a HREF="[% base %]user/add">Admin</a>

You can also use them in any other controller modules like this:

    $c->res->redirect( $c->uri_for('/user/edit') );
		
=head1 DESCRIPTION

This is a controller that will handle every action of a user.

=head2 Methods

=over 12

=item C<add>

This action is used to add a user.

=item C<delete_do>

This action is used to delete a user.

=item C<edit>

This action is used to modify a user.

=item C<history>

This action is used to display what does a user do during its session.

=item C<view>

This action is used to display all users in this system. 

=back

=head1 AUTHOR

Jeff Mo - L<http://jandc.co.cc/>
