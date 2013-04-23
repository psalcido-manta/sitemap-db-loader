package Sitemap::DB::Schema::Result::SitemapFile;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
use Method::Signatures;
use DateTime;
use UUID::Tiny;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Sitemap::DB::Schema::Result::SitemapFile

=cut

__PACKAGE__->table("sitemap_file");

=head1 ACCESSORS

=head2 id

  data_type: 'uuid'
  is_nullable: 0
  size: 16

=head2 filename

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 sitemap_index

  data_type: 'uuid',
  is_nullable: 0

=cut

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
  "sitemap_index",
  { data_type => "uuid", is_nullable => 0, size => 16 },
  "created",
  { data_type => "timestamp with time zone", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("sitemap_file_filename_sitemap_index_unique",['filename','sitemap_index']);

__PACKAGE__->has_many(
	'uris' , 'Sitemap::DB::Schema::Result::SitemapURI',
	{ 'foreign.sitemap_file' => 'self.id' },
	{ 'cascade_copy' => 1, 'cascade_delete' => 1 },
);

__PACKAGE__->belongs_to(
	'index', 'Sitemap::DB::Schema::Result::SitemapIndex',
	{ 'id' => 'sitemap_index' },
	{ 
		is_deferrable => 1,
		join_type => 'LEFT',
		on_delete => 'CASCADE',
		on_update => 'CASCADE',
	},
);

=head1 METHODS

=head2 load

=cut

method load(:$reader!) {
	unless ( -f $self->filename ) {
		if ( -f $self->filename . '.gz' ) {
			system('gunzip',$self->filename);
		}
	}
	my $sf = $reader->parse(filename => $self->filename)->[0];
	foreach my $uri (@{$sf->urls}) {
		$self->uris->create({
			id => create_UUID_as_string(UUID_V4),
			uri => $uri,
			created => DateTime->now(),
		});
	}
}

=head1 HOOKS

=head2 sqlt_deploy_hook

This package uses sqlt_deploy_hook to add an index for the sitemap_index field.

=cut

sub sqlt_deploy_hook {
	my $self = shift;
	my $table = shift;
	$table->add_index(name => 'sitemap_file_sitemap_index',fields => ['sitemap_index']);
}

=head1 AUTHOR

Paul Salcido <psalcido at manta dot com>

=cut

__PACKAGE__->meta->make_immutable;
1;


