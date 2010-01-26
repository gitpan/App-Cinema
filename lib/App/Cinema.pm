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
  
require App::Cinema::Event;
#use App::Cinema::Schema::Result::GenreItems as => 'GenreItems';
#use App::Cinema::Schema::Result::Users as => 'Users';

our $VERSION = '1.14';

__PACKAGE__->setup;

1;

=head1 NAME

App::Cinema - A simple website to demo how easy to provide CRUD via Catalyst framework

=head1 AUTHOR

Jeff Mo - <mo0118@gmail.com>