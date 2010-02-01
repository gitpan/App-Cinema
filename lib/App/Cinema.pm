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
	our $VERSION = '1.16';
}

#__PACKAGE__->config(
#	'View::Email' => {
#
#		# Where to look in the stash for the email information.
#		# 'email' is the default, so you don't have to specify it.
#		stash_key => 'email',
#
#		# Define the defaults for the mail
#		default => {
#
#			# Defines the default content type (mime type). Mandatory
#			content_type => 'text/plain',
#
#			# Defines the default charset for every MIME part with the
#			# content type text.
#			# According to RFC2049 a MIME part without a charset should
#			# be treated as US-ASCII by the mail client.
#			# If the charset is not set it won't be set for all MIME parts
#			# without an overridden one.
#			# Default: none
#			charset => 'utf-8'
#		},
#
#		# Setup how to send the email
#		# all those options are passed directly to Email::Send
#		sender => {
#
#			# if mailer doesn't start with Email::Sender::Transport::,
#			# then this is prepended.
#			mailer => 'SMTP',
#
#			# mailer_args is passed directly into Email::Send
#			mailer_args => {
#				host     => 'mail.jandc.co.cc',    # defaults to localhost
#				username => 'sman',
#				password => 'bubu0319',
#			}
#		}
#	}
#);

#after this line, the $VERSION of other classes are configured
__PACKAGE__->setup;

1;

=head1 NAME

App::Cinema - a demo website for Catalyst framework 

=head1 AUTHOR

Jeff Mo - <mo0118@gmail.com>
