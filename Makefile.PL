
use strict;
use warnings;

use 5.010000;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Embed a web user interface into your PlugAuth server",
  "AUTHOR" => "Graham Ollis <gollis\@sesda3>",
  "BUILD_REQUIRES" => {
    "File::HomeDir" => 0,
    "File::HomeDir::Test" => 0,
    "Module::Build" => "0.3601",
    "Path::Class::Dir" => 0,
    "Test::Mojo" => 0,
    "Test::More" => 0,
    "YAML" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "DISTNAME" => "PlugAuth-Plugin-WebUI",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "PlugAuth::Plugin::WebUI",
  "PREREQ_PM" => {
    "PlugAuth" => "0.04",
    "PlugAuth::Role::Plugin" => 0,
    "PlugAuth::Role::Welcome" => 0,
    "PlugAuth::WebUI" => 0,
    "Role::Tiny::With" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.01",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



