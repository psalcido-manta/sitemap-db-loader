package Sitemap::DB::Reader::url;

=head1 NAME

Sitemap::DB::Reader::url

=head1 DESCRIPTION

Container for xml parsing.

=cut

use Moose;
BEGIN {
	extends 'Sitemap::DB::Reader::Base';
}

=head1 METHODS

=head2 loc

=cut

sub loc {
	my $self = shift;
	my ($item) = (grep { UNIVERSAL::isa($_,'Sitemap::DB::Reader::loc') } @{$self->Kids});
	$item;
}

1;
