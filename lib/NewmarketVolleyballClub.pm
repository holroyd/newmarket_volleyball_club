package NewmarketVolleyballClub;
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::Database;
use Flickr::API;

# This method will run once at server start
sub startup {
	my $self = shift;
	
	$self->plugin('database', {
		dsn      => 'dbi:mysql:database=nvc',
	    username => 'nvc',
	    password => 'Wm/$J.XhCJK7RaVxbe',
	    helper   => 'db'
	});

	my $flickrApiKey = "96387e565c4de6d5792134af8354ae04";
	my $flickrSecret = "fdbcefc34eaa5781";
	
	$self->defaults(flickr => Flickr::API->new({
			'key'    => $flickrApiKey,
	    	'secret' => $flickrSecret,
	    	'unicode'=> 0,
		})
	);

	# Documentation browser under "/perldoc"
	$self->plugin('PODRenderer');

	$self->secrets(["ffgawgwvwc3MioGK3"]);
	$self->defaults(layout => "default");
	$self->defaults(title => "NVC - ");

	# Helpers
	$self->helper_leagues();
	$self->helper_main_menu();
	$self->helper_team_menu();
	

	# Router
	my $r = $self->routes;

  	# Normal route to controller
  	$r->get('/')->to('Home#home');
	$r->get('/home')->to('Home#home');
	$r->get('/teams')->to('Teams#teams');
	$r->get('/teams/:leagueId')->to('Teams#teams');
	$r->get('/fixtures')->to("Fixtures#fixtures");
	$r->get('/fixtures/match/:matchNumber')->to("Fixtures#fixtureMatch");
	$r->get('/pancake_league')->to("PancakeLeague#pancake_league");
	$r->get('/contact')->to("Contact#contact");
}

sub helper_main_menu {
	my $self = shift;
	$self->helper(menu_items => sub {
		my $self = shift;
		my $page = shift;
		my $completeMenuItems = "";
		for my $menuItem ('home', 'teams', 'fixtures', 'pancake league', 'contact') {
			$completeMenuItems .= "<li";
			(my $link = $menuItem) =~ s/ /_/g;
			if($menuItem eq $page) {
				$completeMenuItems .= " class='current'>" . $menuItem . "</li>";
			} else {
				$completeMenuItems .= "><a href='" . $self->url_for($link) . "'>" . $menuItem . "</a></li>"
			}
		}
		return $completeMenuItems;
	});
}

sub helper_team_menu {
	my $self = shift;
	$self->helper(team_menu => sub {
		my $self = shift;
		my $leagueId = shift;
		my $leagues = $self->leagues();
		my $completeTeams .= "<li" . (!$leagueId ? " class='current'>all" : "><a href='" . $self->url_for('teams') ."'>all</a>") . "</li>";
		foreach my $league (@$leagues) {
			if($leagueId && $leagueId == $league->{'id'}) {
				$completeTeams .= "<li class='current'>" . $league->{'description'} . "</li>";
			} else {
				$completeTeams .= "<li><a href='/teams/" . $league->{'id'} . "'>" . $league->{'description'} . "</a></li>";
			}
		}
		return $completeTeams;
	});
}

sub helper_leagues {
	my $self = shift;
	$self->helper(leagues => sub {
		my $sth = $self->db->prepare("select id, name, description from league order by order_by");
		$sth->execute();
		my $leagues = $sth->fetchall_arrayref({});
		$sth->finish();
		return $leagues;
	});
}

1;
