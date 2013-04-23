package Sitemap::DB::Reader::urlset;

use Moose;

=head1 NAME

Sitemap::DB::Reader::urlset

=head1 DESCRIPTION

Container for xml parsing.

=cut

BEGIN {
	extends 'Sitemap::DB::Reader::Base';
}

=head1 METHODS

=head2 urls

Returns the urls from this object.

=cut

sub urls {
	my $self = shift;
	return [ map { $_->loc->text } grep { UNIVERSAL::isa($_,'Sitemap::DB::Reader::url') } @{$self->Kids} ];
}

=head1 AUTHOR

Paul Salcido <psalcido at manta dot com>

=cut

1;
