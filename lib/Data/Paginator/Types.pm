package Data::Paginator::Types;
use MooseX::Types -declare => [qw(
    PositiveInt
)];

use MooseX::Types::Moose qw(Int);

subtype PositiveInt,
    as Int,
    where { $_ >= 0 },
    message { 'Number is not equal to or larger than 0' };

1;