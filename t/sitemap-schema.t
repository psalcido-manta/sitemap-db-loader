use Test::More;

BEGIN {
	use_ok('Sitemap::DB::Schema') || print 'Bail out!';
}

# Putting in temporary defaults for testing.
my $conn = $ENV{SDB_CONNECTION_STRING};
my $user = $ENV{SDB_USERNAME};
my $pass = $ENV{SDB_PASSWORD};

SKIP: {
	skip("Set environment SDB_CONNECTION_STRING, SDB_USERNAME and SDB_PASSWORD to continue.", 100) unless ($conn && $user && $pass);
	my $schema = Sitemap::DB::Schema->connect($conn,$user,$pass);
	ok(ref($schema),"Schema is an object TODO: Change ok to isa_ok");
	eval {
		$schema->deploy;
	};
	ok(!$@,"Schema can deploy");
}

done_testing();
