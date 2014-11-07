package NewmarketVolleyballClub::Controller::Home;
use Mojo::Base 'Mojolicious::Controller';

sub home {
	my $self = shift;
	my $sql = qq {
		select 
			id, title, title_uri, date, formatted_date,
			image_uri, image_caption, title_uri, result, 
			text
		from 
			news_vw
		order by 
			date desc
	};
	my $sth = $self->db->prepare($sql);
	$sth->execute();
	my $news = $sth->fetchall_arrayref({});
	$sth->finish();
	my $newsLinks = $self->newsLinks($news);
	$self->stash->{"title"}  = $self->stash->{"title"} . "Home";
	$self->render(page => "home", headline => shift(@$newsLinks), news => $newsLinks);
}


sub newsLinks {
	my ($self, $news) = @_;
	my $sql = "select id, link, uri from news_link where news_id = ? order by order_by";
	my $sth = $self->db->prepare($sql);
	my @newsLinks;
	foreach my $newsItem (@$news) {
		$sth->execute($newsItem->{"id"});
		my $newsLinks = $sth->fetchall_arrayref({});
		push(@newsLinks, {"news" => $newsItem, "links" => []});
		foreach my $link (@$newsLinks) {
			push(@{$newsLinks[$#newsLinks]->{"links"}}, $link);
		}
	}
	$sth->finish();
	return \@newsLinks;
}

1;