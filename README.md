![alt text](http://www.dota2wiki.com/images/2/27/Crystal_Maiden_icon.png "CM") CM
==

 - Generate ebuilds for perl6 modules using data from ecosystem
 - Process code compilation / testing / installation via eclass
 - use gentoo-perl6 overlay.
 
run `cm --help` for help

``` perl
my $filename =
    $fnm
    ~ '-'
    ~ ( $x.version eq "*" ?? '9999' !! $x.version )
    ~ '.ebuild';
my $ebuild = $filename eq '-' ?? $*OUT !! open $pth ~ $filename, :w;
my $homepage =
    ($x.metainfo{'source-url'})\
        .subst('.git', '')\
        .subst('git', 'https');
$ebuild.print(
    ebuild_template()\
        .subst(/^\n/, '')\
        .subst('$homepage', $homepage)\
        .subst('$description', $x.metainfo{'description'})\
        .subst('$git', $x.metainfo{'source-url'})\
        .subst('$depend', 
            pformat($x.dependencies.Str\
                .split(' ')\
                .map({ $_ ?? "dev-perl/$_" !! () })\
                .join("\n") ))
```
