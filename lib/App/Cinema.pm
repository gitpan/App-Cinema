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

our $VERSION = '1.12';

# Start the application
__PACKAGE__->setup;

1;

=head1 NAME

App::Cinema - Main class