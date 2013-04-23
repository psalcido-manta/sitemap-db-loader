package Sitemap::DB::Reader::sitemapindex;

=head1 NAME

Sitemap::DB::Reader::loc

=head1 DESCRIPTION

Location XML Parsed.

=cut

use Moose;

BEGIN {
	extends 'Sitemap::DB::Reader::Base';
}

=head1 METHODS

=head2 sitemaps

=cut

sub sitemaps {
	my $self = shift;
	[ map { $_->loc->text =~ s/http:\/\/.*?\///r } @{$self->get_children_of_class(class => 'Sitemap::DB::Reader::sitemap')} ];
}

1;
