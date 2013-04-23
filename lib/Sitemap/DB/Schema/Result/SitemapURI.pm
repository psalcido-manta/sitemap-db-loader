package Sitemap::DB::Schema::Result::SitemapURI;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Sitemap::DB::Schema::Result::SitemapFile

=cut

__PACKAGE__->table("sitemap_uri");

=head1 ACCESSORS

=head2 id

  data_type: 'uuid'
  is_nullable: 0
  size: 16

=head2 filename

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 sitemap_file

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
  "uri",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "sitemap_file",
  { data_type => "uuid", is_nullable => 0, size => 16 },
  "created",
  { data_type => "timestamp with time zone", is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
	'file', 'Sitemap::DB::Schema::Result::SitemapFile',
	{ 'id' => 'sitemap_file' },
	{ 
		is_deferrable => 1,
		join_type => 'LEFT',
		on_delete => 'CASCADE',
		on_update => 'CASCADE',
	},
);

=head1 HOOKS

=head2 sqlt_deploy_hook

This package uses sqlt_deploy_hook to add indices for the uri and sitemap_file fields.

=cut

sub sqlt_deploy_hook {
	my $self  = shift;
	my $table = shift;
	$table->add_index(name => 'sitemap_uri_uri_index',fields => ['uri']);
	$table->add_index(name => 'sitemap_uri_sitemap_file_index',fields => ['sitemap_file']);
}

=head1 AUTHOR

Paul Salcido <psalcido at manta dot com>

=cut

__PACKAGE__->meta->make_immutable;
1;


