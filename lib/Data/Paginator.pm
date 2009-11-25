package Data::Paginator;
use Moose;

use Data::Paginator::Types qw(PositiveInt);

our $VERSION = '0.01';

has current_page => (
    is => 'ro',
    isa => PositiveInt,
    default => 1
);

has entries_per_page => (
    is => 'ro',
    isa => PositiveInt,
    required => 1
);

has last_page => (
    is => 'ro',
    isa => PositiveInt,
    lazy_build => 1,
);

has total_entries => (
    is => 'ro',
    isa => PositiveInt,
    required => 1
);

sub _build_last_page {
    my $self = shift;

    my $pages = $self->total_entries / $self->entries_per_page;
    my $last_page;

    if ($pages == int $pages) {
        $last_page = $pages;
    } else {
        $last_page = 1 + int($pages);
    }

    $last_page = 1 if $last_page < 1;
    return $last_page;
}

sub entries_on_this_page {
    my $self = shift;

    if ($self->total_entries == 0) {
        return 0;
    } else {
        return $self->last - $self->first + 1;
    }
}

sub first {
    my $self = shift;

    if ($self->total_entries == 0) {
        return 0;
    } else {
        return (($self->current_page - 1) * $self->entries_per_page) + 1;
    }
}

sub first_page {
    return 1;
}

sub last {
    my $self = shift;

    if ($self->current_page == $self->last_page) {
        return $self->total_entries;
    } else {
        return ($self->current_page * $self->entries_per_page);
    }
}

sub next_page {
    my $self = shift;

    $self->current_page < $self->last_page ? $self->current_page + 1 : undef;
}

sub previous_page {
    my $self = shift;

    if ($self->current_page > 1) {
        return $self->current_page - 1;
    } else {
        return undef;
    }
}

sub skipped {
    my $self = shift;

    my $skipped = $self->first - 1;
    return 0 if $skipped < 0;
    return $skipped;
}

sub splice {
    my ($self, $array) = @_;

    my $top = @$array > $self->last ? $self->last : @$array;
    return () if $top == 0;    # empty
    return @{$array}[ $self->first - 1 .. $top - 1 ];
}

1;

=head1 NAME

Data::Paginator - Pagination with Moose

=head1 SYNOPSIS

    use Data::Paginator;

    my $pager = Data::Paginator->new(
        current_page => 1,
        entries_per_page => 10
        total_entries => 100,
    );

    print "First page: ".$page->first_page."\n";
    print "Last page: ".$page->last_page."\n";
    print "First entry on page: ".$page->first."\n";
    print "Last entry on page: ".$page->last."\n";

=head1 DESCRIPTION

This is yet another pagination module.  It only exists because none of the
other pager modules are written using Moose.  Sometimes there is a Moose
feature – MooseX::Storage, in my case – that you need and it's a pain when
you can't use it with an existing module.  This module aims to be completely
compatible with the venerable L<Data::Page>.

=head1 ATTRIBUTES

=head2 current_page

The current page.  Defaults to 1.

=head2 entries_per_page

The number of entries per page, required at instantiation.

=head2 last_page

Returns the number of the last page.  Lazily computed, so do not set.

=head2 total_entries

The total number of entries this pager is covering.  Required at
instantiation.

=head1 METHODS

=head2 entries_on_this_page

Returns the number of entries on this page.

=head2 first

Returns the number of the first entry on the current page.

=head2 first_page

Always returns 1.

=head2 last

Returns the number of the last entry on the current page.

=head2 next_Page

Returns the page number of the next page if one exists, otherwise returns
false.

=head2 previous_page

Returns the page number of the previous page if one exists, otherwise returns
undef.

=head2 skip

This method is useful paging through data in a database using SQL LIMIT
clauses. It is simply $page->first - 1:

=head2 splice

Takes in an arrayref and returns only the valies which are on the current
page.



=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 ACKNOWLEDGEMENTS

Léon Brocard and his work on L<Data::Page>.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
