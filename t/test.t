use strict;
use warnings;
use 5.010001;
#use Test::Clustericious::Log;
use Test2::Plugin::FauxHomeDir;
use File::Glob qw( bsd_glob );
use Test::More tests => 2;
use Test::Mojo;
use Path::Class::Dir;
use YAML qw( DumpFile );

delete $ENV{HARNESS_ACTIVE};
$ENV{LOG_LEVEL} = "TRACE";

my $etc = Path::Class::Dir
  ->new(bsd_glob '~/etc');
$etc->mkpath(0, 0700);

DumpFile($etc->file('PlugAuth.conf')->stringify, {
  plugins => [
    { 'PlugAuth::Plugin::WebUI' => { test => 1} },
  ],
});

my $t = Test::Mojo->new("PlugAuth");

$t->get_ok("/t")
  ->status_is(200);
