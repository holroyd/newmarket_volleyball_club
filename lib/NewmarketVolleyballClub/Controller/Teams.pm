package NewmarketVolleyballClub::Controller::Teams;
use Mojo::Base 'Mojolicious::Controller';

sub teams {
	my $self = shift;
	my $players;
	my $sql;
	if(exists $self->stash->{'leagueId'}) {
		$players = $self->playersByLeagueId($self->stash->{'leagueId'});
	} else {
		$players = $self->allPlayers();
		$self->stash->{'leagueId'} = undef;
	}
	$self->stash->{"title"}  = $self->stash->{"title"} . "Teams";
	$self->render(page => "teams", players => $players);
}

sub allPlayers {
	my $self = shift;
	my $sql = qq {
		SELECT 
		    id, fullname, age, height, weight, positions, image_uri
		FROM
		    player_info_vw
		ORDER BY surname, forename
	};
	my $sth = $self->db->prepare($sql);
	$sth->execute();
	my $players = $sth->fetchall_arrayref({});
	return $players;
}

sub playersByLeagueId {
	my $self = shift;
	my $leagueId = $self->stash->{"leagueId"};
	my $sql = qq {
		select
			id, fullname, age, height, weight, positions, image_uri
		from
			player_league_vw
		where
			league_id = ?
	};
	my $sth = $self->db->prepare($sql);
	$sth->execute($leagueId);
	my $players = $sth->fetchall_arrayref({});
	return $players;
}

1;