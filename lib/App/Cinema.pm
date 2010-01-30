package App::Cinema;
use Moose;
use Catalyst::Runtime '5.70';
use Catalyst qw/
  -Debug
  ConfigLoader
  Static::Simple
  StackTrace

  Authentication
  Authorization::Roles
  Session
  Session::Store::FastMmap
  Session::State::Cookie
  /;

BEGIN {
	our $VERSION = '1.142';
}

__PACKAGE__->setup;

#after this line, the $VERSION of other
#classes are configured

1;

=head1 NAME

App::Cinema - demo how to build a dynamic web application effectively 
via Catalyst framework 

=head1 AUTHOR

Jeff Mo - <mo0118@gmail.com>
