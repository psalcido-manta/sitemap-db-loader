#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Sitemap::DB' ) || print "Bail out!\n";
}

diag( "Testing Sitemap::DB $Sitemap::DB::VERSION, Perl $], $^X" );
