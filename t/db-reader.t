use Test::More;
use Data::Dumper;

BEGIN {
	use_ok('Sitemap::DB::Reader') || print 'Bail out!';
}

{
	open(my $fh,'>/tmp/test-db-reader.xml');
	print $fh <<"FILE";
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.google.com/schemas/sitemap/0.9">
<url><loc>http://www.example.com/url-1/</loc><changefreq>yearly</changefreq></url>
<url><loc>http://www.example.com/url-2/</loc><changefreq>yearly</changefreq></url>
</urlset>
FILE
	close($fh);
	my $p = Sitemap::DB::Reader->new(working_directory => '/tmp');
	is($p->full_filename(filename => 'test-db-reader.xml'),'/tmp/test-db-reader.xml');
	my $d = $p->parse(filename => 'test-db-reader.xml');
	can_ok($d->[0],'urls');
	is_deeply($d->[0]->urls,['http://www.example.com/url-1/','http://www.example.com/url-2/']);
}

{
	open(my $fh,'>/tmp/test-db-reader-index.xml');
	print $fh <<"FILE";
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.google.com/schemas/sitemap/0.9">
<sitemap>
        <loc>http://www.example.com/sitemap-1.xml</loc>
        <lastmod>2013-04-19</lastmod>
</sitemap>
<sitemap>
        <loc>http://www.example.com/sitemap-2.xml</loc>
        <lastmod>2013-04-19</lastmod>
</sitemap>
<sitemap>
        <loc>http://www.example.com/sitemap-3.xml</loc>
        <lastmod>2013-04-19</lastmod>
</sitemap>
</sitemapindex>
FILE
	close($fh);
	my $p = Sitemap::DB::Reader->new(working_directory => '/tmp/');
	is($p->full_filename(filename => 'test-db-reader-index.xml'),'/tmp/test-db-reader-index.xml');
	my $d = $p->parse(filename => 'test-db-reader-index.xml');
	is_deeply($d->[0]->sitemaps,['http://www.example.com/sitemap-1.xml','http://www.example.com/sitemap-2.xml','http://www.example.com/sitemap-3.xml',]);
}

done_testing();
