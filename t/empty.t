#!/usr/bin/perl -wT

use strict;
use Test::More;
use_ok('Data::Paginator');

my $pager = Data::SearchEngine::Paginator->new(
    current_page => 0,
    entries_per_page => 10,
    total_entries => 0
);

diag $pager->current_page;


