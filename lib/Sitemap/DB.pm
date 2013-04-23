package Sitemap::DB;

use Moose;

use Sitemap::DB::Schema;

use Method::Signatures;
use Sitemap::DB::Reader;

=head1 NAME

Sitemap::DB - Load Sitemaps into a database for testing.

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

First, create a database (PostgreSQL demo):

	postgres=# create user sitemap_db
	postgres-# password 'sitemap_db';
	CREATE ROLE
	postgres=# create database sitemap_db;
	CREATE DATABASE
	postgres=# grant all on database sitemap_db to sitemap_db;
	GRANT

Then run with deploy.

=cut

our $VERSION = '0.01';

=head1 REQUIRED SETTINGS

=cut

=head2 connection_string

The database connection string.

=cut

has 'connection_string' => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

=head2 username

The database username

=cut

has 'username' => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

=head2 password

The database password

=cut

has 'password' => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

=head1 OPTIONAL SETTINGS

=head2 working_directory

The directory where the sitemaps and their indexes are.  Defaults to '.'

=cut

has 'working_directory' => (
	is => 'ro',
	isa => 'Str',
	default => '.',
);

=head2 index_file_glob

A file glob that will be used to pick up the index files.  The sitemap files
will be loaded based on what is in the index files.  All files must be in
the working directory.

=cut

has 'index_file_glob' => (
	is => 'ro',
	isa => 'Str|Undef',
	default => undef,
);

=head2 deploy_tables

Create the necessary tables when starting the process; this is nondestructive.

Defaults to false.

=cut

has 'deploy_tables' => (
	is => 'ro',
	isa => 'Bool',
	default => 0,
);

=head2 empty_index_data

Delete the index record (and it's child records) from the database when trying
to load.  I strongly recommend this option.

Defaults to false.

=cut

has 'empty_index_data' => (
	is => 'ro',
	isa => 'Bool',
	default => 0,
);

=head1 ACCESSORS

=head2 schema

A built field, containing the reference to a Sitemap::DB::Schema object based
on the input values.

=cut

has 'schema' => (
	is => 'ro',
	isa => 'Sitemap::DB::Schema',
	builder => 'build_schema',
	lazy => 1,
);

=head2 reader

=cut

has 'reader' => (
	is => 'ro',
	isa => 'Sitemap::DB::Reader',
	builder => 'build_reader',
	lazy => 1,
);

=head1 METHODS

=head2 load

=cut

method load() {
	chdir($self->working_directory);
	$self->schema->load(files => [ @{$self->files} ],reader => $self->reader);
}

=head2 files

=cut

method files() {
	chdir($self->working_directory);
	[ glob($self->index_file_glob) ];
}

=head1 BUILDERS

=head2 build_schema

Creates a new Sitemap::DB::Schema object, based on passed values.

=cut

sub build_schema {
	my $self = shift;
	return Sitemap::DB::Schema->connect(
		$self->connection_string,
		$self->username,
		$self->password,
	);
}

=head2 build_reader

=cut

sub build_reader {
	Sitemap::DB::Reader->new(working_directory => $_[0]->working_directory);
}

=head1 AUTHOR

Paul Salcido, C<< <psalcido at manta.com> >>

=head1 BUGS

I don't have a bug tracker up yet.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Sitemap::DB


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Sitemap-DB>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Sitemap-DB>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Sitemap-DB>

=item * Search CPAN

L<http://search.cpan.org/dist/Sitemap-DB/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Paul Salcido.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Sitemap::DB
