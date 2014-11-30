use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    name                => 'Acme-EverythingBecomes',
    module_name         => 'Acme::EverythingBecomes',
    license             => 'perl',
    dist_author         => 'Dai Okabayashi <bayashi@cpan.org>',
    dist_version_from   => 'lib/Acme/EverythingBecomes.pm',
    configure_requires  => {
        'Module::Build' => 0.38,
    },
    build_requires      => {
        'Test::More' => 0.88,
    },
    requires => {
        'perl' => '5.008001',
        'Carp' => 0,
    },
    add_to_cleanup      => [ 'Acme-EverythingBecomes-*' ],
    meta_merge     => {
      resources => {
        repository  => 'http://github.com/bayashi/Acme-EverythingBecomes',
        bugtracker  => 'http://github.com/bayashi/Acme-EverythingBecomes/issues',
      }
    },
    recursive_test_files => 1,
    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? ['t/', 'xt/'] : ['t/'],
);

$builder->create_build_script();
