![alt text](http://www.dota2wiki.com/images/2/27/Crystal_Maiden_icon.png "CM") Crystal Maiden
=============================================================================================

 - Generate ebuilds for perl6 modules using data from ecosystem
 - Process code compilation / testing / installation via eclass
 - use gentoo-perl6 overlay.

``` perl
sub MAIN(*@args, Bool :$debug = False, Bool :$help = False) {
    if $help { help() }
    else {
        if !@args { help() }
        elsif @args[0] eq "src" {
            if @args[1] eq "configure" {
                printlibpath() }
            elsif @args[1] eq "compile" {
                pandacompile() }
            elsif @args[1] eq "test" {
                run <prove -e perl6 -r t/> }
            elsif @args[1] eq "install" {
                pandainstall(@args[2]) }
            }
        elsif @args[0] eq "module" {
            if @args[1] eq "list" {
                my $pandadir = %*CUSTOM_LIB<site> ~ '/panda';
                list(panda => Panda.new(
                    srcdir       => "$pandadir/src",
                    destdir      =>  $destdir,
                    statefile    => "$pandadir/state",
                    projectsfile => "$pandadir/projects.json"
                    )) }
            elsif @args[1] eq "rebuild" {
                rebuild() }
            }
        else {
            if $debug {
                say 'we expect to get: ';
                for @args -> $m { say " --> $m"; };
                }
            my $pandadir = %*CUSTOM_LIB<site> ~ '/panda';
            projectinfo(Panda.new(
                srcdir       => "$pandadir/src",
                destdir      =>  $destdir,
                statefile    => "$pandadir/state",
                projectsfile => "$pandadir/projects.json"
                ), @args, $debug);
```
