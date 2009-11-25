use inc::Module::Install;

name     'Data-Paginator';
all_from 'lib/Data/Paginator.pm';
author   q{Cory G Watson <gphat@cpan.org>};
license  'perl';

build_requires 'Test::More';

requires 'Moose';

WriteAll;

