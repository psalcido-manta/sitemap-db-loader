package Sitemap::DB::Schema::Result::SitemapIndex;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
use Method::Signatures;
use UUID::Tiny;
use DateTime;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Sitemap::DB::Schema::Result::SitemapIndex

=cut

__PACKAGE__->table("sitemap_index");

=head1 ACCESSORS

=head2 id

  data_type: 'uuid'
  is_nullable: 0
  size: 16

=head2 filename

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 created

  data_type: 'timestamp with time zone'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "uuid", is_nullable => 0, size => 16 },
  "filename",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "created",
  { data_type => "timestamp with time zone", is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("sitemap_index_filename_unique",['filename']);

__PACKAGE__->has_many(
	'files' , 'Sitemap::DB::Schema::Result::SitemapFile',
	{ 'foreign.sitemap_index' => 'self.id' },
	{ 'cascade_copy' => 1, 'cascade_delete' => 1 },
);

=head1 METHODS

=head2 load

=cut

method load(:$reader!) {
	my $data = $reader->parse(filename => $self->filename)->[0];
	foreach my $sitemap (@{$data->sitemaps}) {
		my $sm = $self->files->create({
			id => create_UUID_as_string(UUID_V4),
			filename => $sitemap,
			created => DateTime->now(),
		});
		$sm->load(reader => $reader);
	}
}

=head1 AUTHOR

Paul Salcido <psalcido at manta dot com>

=cut

__PACKAGE__->meta->make_immutable;

1;


