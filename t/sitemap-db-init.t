use Test::More;

BEGIN {
	use_ok('Sitemap::DB') || print 'Bail out!';
}

{
	# Test basic settings and options.
	my $sd = Sitemap::DB->new(
		connection_string => 'dbi:Pg:dbname=sitemap_db;host=localhost',
		username => 'sitemap_db',
		password => 'sitemap_db_pass',	
		working_directory => '/tmp',
		index_file_glob => '*index*',
		deploy_tables => 1,
		empty_index_data => 1,
	);

	isa_ok($sd,'Sitemap::DB');
	is($sd->connection_string,'dbi:Pg:dbname=sitemap_db;host=localhost');
	is($sd->username,'sitemap_db');
	is($sd->password,'sitemap_db_pass');
	is($sd->working_directory,'/tmp');
	is($sd->index_file_glob,'*index*');
	is($sd->deploy_tables,1);
	is($sd->empty_index_data,1);
}

{
	# Test defaults
	my $sd = Sitemap::DB->new(
		connection_string => 'dbi:Pg:dbname=sitemap_db;host=localhost',
		username => 'sitemap_db',
		password => 'sitemap_db_pass',	
	);

	is($sd->working_directory,'.');
	is($sd->index_file_glob,undef);
	is($sd->deploy_tables,0);
	is($sd->empty_index_data,0);
}

{
	# Test options breakage.
	eval {
		my $sd = Sitemap::DB->new;
	};
	ok($@,"Required options, all missing");
	
	eval {
		my $sd = Sitemap::DB->new(
			connection_string => 'db:Pg:dbname=sitemap_db;host=localhost',
			username => 'sitemap_db',
		);
	};
	like($@,qr/password/,"Missing password");
	eval {
		my $sd = Sitemap::DB->new(
			connection_string => 'db:Pg:dbname=sitemap_db;host=localhost',
			password => 'sitemap_db',
		);
	};
	like($@,qr/username/,"Missing username");
	eval {
		my $sd = Sitemap::DB->new(
			username => 'sitemap_db',
			password => 'sitemap_db',
		);
	};
	like($@,qr/connection_string/,"Missing connection string");
}

done_testing();
