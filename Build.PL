
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::HomeDir" => 0,
    "File::HomeDir::Test" => 0,
    "Module::Build" => "0.3601",
    "Path::Class::Dir" => 0,
    "Test::Mojo" => 0,
    "Test::More" => 0,
    "YAML" => 0
  },
  "configure_requires" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Embed a web user interface into your PlugAuth server",
  "dist_author" => [
    "Graham Ollis <gollis\@sesda3>"
  ],
  "dist_name" => "PlugAuth-Plugin-WebUI",
  "dist_version" => "0.01",
  "license" => "perl",
  "module_name" => "PlugAuth::Plugin::WebUI",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "PlugAuth" => "0.04",
    "PlugAuth::Role::Plugin" => 0,
    "PlugAuth::Role::Welcome" => 0,
    "PlugAuth::WebUI" => 0,
    "Role::Tiny::With" => 0,
    "perl" => "v5.10.0",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
