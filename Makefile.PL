use inc::Module::Install;

name     'Sitemap-DB';
all_from 'lib/Sitemap/DB.pm';
author   q{Paul Salcido <psalcido@manta.com>};
license  'perl';

build_requires 'Test::More';

requires 'Moose';
requires 'DBIC::Class';
requires 'File::Spec';
requires 'XML::Parser';
requires 'Method::Signatures';

auto_install;

WriteAll;

