package NewmarketVolleyballClub::Controller::PancakeLeague;
use Mojo::Base 'Mojolicious::Controller';

sub pancake_league {
	my $self = shift;
	$self->render(page => 'pancake league');
}

1;