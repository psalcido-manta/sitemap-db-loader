package Sitemap::DB::Reader;

use Moose;

use XML::Parser;
use File::Spec;
use Method::Signatures;
use Sitemap::DB::Reader::urlset;
use Sitemap::DB::Reader::url;
use Sitemap::DB::Reader::sitemapindex;
use Sitemap::DB::Reader::loc;
use Sitemap::DB::Reader::Characters;
use Sitemap::DB::Reader::sitemap;
use Sitemap::DB::Reader::sitemapindex;


=head1 NAME

Sitemap::DB::Reader

=head1 DESCRIPTION

This reads sitemap files.

=head1 SYNOPSIS

	my $reader = Sitemap::DB::Reader->new;

=head1 OPTIONAL SETTINGS

=head2 working_directory

Defaults to '.'

=cut

has 'working_directory' => (
	is => 'ro',
	isa => 'Str',
	default => '.',
);

=head1 BUILT ACCESSORS

=head2 parser

An XML Parser.

=cut

has 'parser' => (
	is => 'ro',
	isa => 'XML::Parser',
	builder => 'build_parser',
	lazy => 1,
);

=head1 METHODS

=head2 full_filename(filename => ...)

=cut

method full_filename(:$filename!) {
	File::Spec->catfile($self->working_directory,$filename);
}

=head2 parse(filename => ...)

=cut

method parse(:$filename!) {
	$self->parser->parsefile($self->full_filename(filename => $filename));
}

=head1 BUILDER METHODS

=head2 build_parser

=cut

sub build_parser {
	XML::Parser->new(Style => 'Objects');
}

=head1 AUTHOR

Paul Salcido <psalcido at manta dot com>

=cut

1;
