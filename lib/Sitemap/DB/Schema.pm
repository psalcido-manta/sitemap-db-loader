package Sitemap::DB::Schema;

use UUID::Tiny;
use DateTime;
use Sitemap::DB::Reader;

=head1 NAME

Sitemap::DB::Schema

=head1 DESCRIPTION

This is a DBIC::Class::Schema object for the database connections to load
sitemap files into a database.

=head1 AUTHOR

Paul Salcido <psalcido at manta dot com>

=cut

use Moose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';

use Method::Signatures;

__PACKAGE__->load_namespaces;

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

=head1 METHODS

=head2 load(:$files!,:$reader!)

=cut

method load(:$files!,:$reader!) {
	foreach my $file (@{$files}) {
		my $si = $self->resultset('SitemapIndex')->create({
			id => create_UUID_as_string(UUID_V4),
			filename => $file,
			created => DateTime->now(),
		});
		$si->load(reader => $reader);
		#$self->load_index($reader->parse($file);
	}
}

1;
