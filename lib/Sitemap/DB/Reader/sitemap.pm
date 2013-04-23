package Sitemap::DB::Reader::sitemap;

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

=head2 loc

=cut

sub loc {
	$_[0]->get_first_child_of_class(class => 'Sitemap::DB::Reader::loc');
}

1;
