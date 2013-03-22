use v6;
use Test;

plan 2;

my $meta = 'ufo-9999.ebuild';

unlink $meta if $meta.IO.e;
nok $meta.IO.e;

run (<perl6 bin/cm ufo>);
ok $meta.IO.e;
