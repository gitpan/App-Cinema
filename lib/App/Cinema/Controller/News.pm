package App::Cinema::Controller::News;

#use Moose;
#use namespace::autoclean;
use strict;
use warnings;
use base qw(Catalyst::Controller::FormBuilder);

sub add : Local Form {
	my ( $self, $c ) = @_;
	my $form = $self->formbuilder;

	if ( $form->submitted && $form->validate ) {
		my $row = $c->model('MD::News')->create(
			{
				title        => $form->field('name'),
				desc         => $form->field('desc'),
				release_date => HTTP::Date::time2iso(time),
			}
		);
		$c->flash->{message} = 'Created News : ' . $row->title;
		$c->res->redirect( $c->uri_for('add') );
	}
}

sub view : Local {
	my ( $self, $c ) = @_;
	my $news = $c->model('MD::News')
	  ->search( undef, { order_by => { -desc => 'release_date' } } );
	$c->stash->{news} = $news;
}
1;

=head1 NAME

App::Cinema::Controller::News - A controller that handles actions for News.

=head1 SYNOPSIS

You can call its actions in any template files either

    <a HREF="[% Catalyst.uri_for('/news/add') %]">News</a>
    
or

    <a HREF="[% base %]news/add">News</a>

=head1 DESCRIPTION

This is A controller that handles actions for News.

=head2 Methods

=over 12

=item C<add>

This action is used to add a news.

=item C<view>

This action is used to retrieve news data from database and then propagate to view module.

=back

=head1 AUTHOR

Jeff Mo - L<http://jandc.co.cc/>

