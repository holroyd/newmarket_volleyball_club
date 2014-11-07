package NewmarketVolleyballClub::Controller::Fixtures;
use Mojo::Base 'Mojolicious::Controller';

sub fixtures {
	my $self = shift;
	my $sql = "select date, time, home_team, away_team, venue, result, report_uri, has_been_played, league from league_fixtures_vw order by date_time";
	my $sth = $self->db->prepare($sql);
	$sth->execute();
	my $currentDate;
	my @fixturesByDate;
	while(my $leagueFixture = $sth->fetchrow_hashref()) {
		if(scalar(@fixturesByDate) == 0 || $fixturesByDate[$#fixturesByDate]->{"date"} ne $leagueFixture->{"date"}) {
			push(@fixturesByDate, {date => $leagueFixture->{"date"}, has_been_played => $leagueFixture->{"has_been_played"}, fixtures => []});
		}
		push(@{$fixturesByDate[$#fixturesByDate]->{"fixtures"}}, $leagueFixture);
	}
	$sth->finish();
	$self->stash->{"title"}  = $self->stash->{"title"} . "Fixtures";
	$self->render(page => "fixtures", fixtures => \@fixturesByDate);
}


sub fixtureMatch {
	my $self = shift;
	my $matchNumber = $self->stash->{"matchNumber"};
	$self->stash->{"title"} = $self->stash->{"title"} . " Match " . $matchNumber;
	$self->render(page => "fixtures", template => "fixtures/matches/match_$matchNumber");
}

1;