package App::Cinema::Controller::User;
use Moose;
use namespace::autoclean;
BEGIN {
	extends qw/Catalyst::Controller::FormBuilder/;
	our $VERSION = $App::Cinema::VERSION;
}
use TryCatch;
require App::Cinema::Event;

sub login : Local {
	my ( $self, $c ) = @_;

	# Get the username and password from form
	my $username = $c->req->params->{username} || "";
	my $password = $c->req->params->{password} || "";

	# If the username and password values were found in form
	if ( $username && $password ) {
		my $status = $c->authenticate(
			{
				username => $username,
				password => $password
			}
		);
		if ($status) {

			# If successful, then let them use the application
			$c->flash->{message} = "Welcome back, " . $username;
			$c->res->redirect( $c->uri_for('/menu/home') );
			return;
		}
		else {
			$c->flash->{error} = "Bad username or password.";
		}
	}
}

sub logout : Local {
	my ( $self, $c ) = @_;

	# Clear the user's state
	$c->logout;
	$c->flash->{message} = 'Log out successfully.';

	# Send the user to the starting point
	$c->res->redirect( $c->uri_for('/menu/home') );
}

sub history : Local {
	my ( $self, $c ) = @_;
	if ( !$c->user_exists ) {
		$c->stash->{error}    = $c->config->{need_login_errmsg};
		$c->stash->{template} = 'result.tt2';
		return 0;
	}
	my $rs;	
	if ( $c->check_user_roles(qw/admin/) ) {
		$rs = $c->model('MD::Event')->search(
			$c->session->{query},#undef               
			{ rows => 10, order_by => { -desc => 'e_time' } }
		);
	}
	else {
		$rs = $c->model('MD::Event')->search(
			{ $c->flashsession->{query}, uid => $c->user->obj->username() },
			{ rows => 10, order_by => { -desc => 'e_time' } }
		);
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
		try {    #1/24
			my $row = $c->model('MD::Users')->create(
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
			my $e = App::Cinema::Event->new();
			$e->uid( $row->username );
			$e->desc(' created account : ');
			$e->target( $row->username );
			$e->insert($c);

			$c->flash->{message} = 'Added ' . $row->first_name;
			$c->res->redirect( $c->uri_for('/login') );
		}
		catch( DBIx::Class::Exception $e) {
			$c->log->debug( 'cmo:error=', $e, "\n" );
			  $c->stash->{error} =
'This userid is already used in the system. Please choose another one.';
		};
	}
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

		my $e = App::Cinema::Event->new();
		$e->desc(' edited account : ');
		$e->target($id);
		$e->insert($c);

		$c->stash->{message} = 'Edited ' . $user->first_name;
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
		$c->stash->{error}    = $c->config->{need_login_errmsg};
		$c->stash->{template} = 'result.tt2';
		return 0;
	}
	if ( $c->check_user_roles(qw/admin/) ) {
		$c->stash->{users} =
		  $c->model('MD::Users')->search( $c->session->{query} );
	}
	else {
		$c->stash->{users} =
		  $c->model('MD::Users')->search( $c->session->{query},
			{ username => $c->user->obj->username() } );
	}
}

sub delete_do : Local {
	my ( $self, $c, $id ) = @_;
	if ( $c->check_user_roles(qw/admin/) ) {
		$c->model('MD::Users')->find($id)->delete();

		my $e = App::Cinema::Event->new();
		$e->desc(' deleted account : ');
		$e->target($id);
		$e->insert($c);

		$c->flash->{message} = "User deleted";
	}
	else {
		$c->flash->{error} = "You are not authorized to delete this.";
	}
	$c->res->redirect( $c->uri_for('/user/view') );
}

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

Jeff Mo - <mo0118@gmail.com>
