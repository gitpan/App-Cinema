package App::Cinema::Controller::Menu;
use Moose;
use namespace::autoclean;

BEGIN {
	extends qw/Catalyst::Controller/;
	our $VERSION = $App::Cinema::VERSION;
}

sub home : Local {
	my ( $self, $c ) = @_;
	my $result =
	  $c->model('MD::Item')
	  ->search( undef, { rows => 1, order_by => { -desc => 'release_date' } } );
	$c->stash->{items} = $result;
	my $news =
	  $c->model('MD::News')
	  ->search( undef, { rows => 1, order_by => { -desc => 'release_date' } } );
	$c->stash->{news} = $news;
}

sub search : Local {
	my ( $self, $c ) = @_;

	my $genre  = $c->req->params->{sel};
	my $string = $c->req->params->{txt};
	my $str    = $c->req->params->{'txt'};

	my @fields;
	my $uri = '';

	if ( $genre eq 'item' ) {
		@fields = qw/title plot year/;
		$uri    = '/item/view';
	}
	elsif ( $genre eq 'news' ) {
		$uri    = '/news/view';
		@fields = qw/title content/;
	}
	elsif ( $genre eq 'event' ) {
		$uri    = '/user/history';
		@fields = qw/target content/;
	}
	elsif ( $genre eq 'user' ) {
		$uri    = '/user/view';
		@fields = qw/first_name last_name email_address username/;
	}

	my @tokens = $str;
	@fields = cross( \@fields, \@tokens );
	$c->session->{query} = \@fields;
	$c->res->redirect( $c->uri_for($uri) );
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

sub about : Local {
	my ( $self, $c ) = @_;
	$c->stash->{error} = $c->config->{need_login_errmsg}
	  unless $c->user_exists();
}

sub howto : Local {
}

sub dbschema : Local {
	my ( $self, $c ) = @_;
	eval {
		$c->assert_any_user_role(qw/vipuser/);    # only admins can delete
	};
	if ($@) {
		$c->flash->{error} = $c->config->{need_auth_msg};
		$c->res->redirect( $c->uri_for('/menu/about') );
		return;
	}
	$c->forward('howto');
	$c->stash->{template} = 'menu/howto.tt2'; 
	#$c->forward('static/db.txt');		
	#die join "\n", @{ $c->error } if @{ $c->error };
}

1;

=head1 NAME

App::Cinema::Controller::Menu - A controller that handles the request for the MENU link.

=head1 SYNOPSIS

You can call its actions in any template files either

    <a HREF="[% Catalyst.uri_for('/menu') %]">MENU</a>
    
or

    <a HREF="[% base %]menu">MENU</a>

You can also use them in any other controller modules like this:

    $c->res->redirect( $c->uri_for('/menu') );
		
=head1 DESCRIPTION

This is a controller that handles the request for the MENU link.

=head2 Methods

=over 12

=item C<index>

This private action is used to retrieve the data of News and Item from database, choose suitable template,
and then propagate to view module.

=back

=head1 AUTHOR

Jeff Mo - <mo0118@gmail.com>
