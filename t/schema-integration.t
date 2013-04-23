use Test::More;
use Data::Dumper;

BEGIN {
	use_ok('Sitemap::DB') || print 'Bail out!';
}

# Putting in temporary defaults for testing.
my $conn = $ENV{SDB_CONNECTION_STRING};
my $user = $ENV{SDB_USERNAME};
my $pass = $ENV{SDB_PASSWORD};
my $fg = $ENV{SDB_FILEGLOB};
my $wd = $ENV{SDB_WORKING_DIRECTORY};

SKIP: {
	skip("Set environment SDB_CONNECTION_STRING, SDB_USERNAME, SDB_FILEGLOB, SDB_WORKING_DIRECTORY and SDB_PASSWORD to continue.", 100) unless ($conn && $user && $pass && $fg && $wd);
	my $sd = Sitemap::DB->new(connection_string => $conn,username => $user,password => $pass,index_file_glob => $fg,working_directory => $wd);
	isa_ok($sd->schema,'Sitemap::DB::Schema');
	ok(@{$sd->files} > 0);
	diag(Dumper($sd->files));
	$sd->load;
}

done_testing();
