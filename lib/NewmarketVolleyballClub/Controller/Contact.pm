package NewmarketVolleyballClub::Controller::Contact;
use Mojo::Base 'Mojolicious::Controller';

sub contact {
	my $self = shift;
	$self->stash->{"title"}  = $self->stash->{"title"} . "Contact";
	$self->render(page => "contact");
}

1;