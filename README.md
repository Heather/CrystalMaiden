![alt text](http://www.dota2wiki.com/images/2/27/Crystal_Maiden_icon.png "CM") Crystal Maiden
=============================================================================================

 - Generate ebuilds for perl6 modules using data from ecosystem
 - Process code compilation / testing / installation via eclass
 - use gentoo-perl6 overlay.

``` perl
sub MAIN(*@modules, Bool :$debug = False, Bool :$help = False) {
    if $help { help() }
    else {
        if !@modules { help() }
        elsif @modules[0] eq "src" {
            if @modules[1] eq "configure" {
                printlibpath() }
            elsif @modules[1] eq "compile" {
                pandacompile() }
            elsif @modules[1] eq "test" {
                run <prove -e perl6 -r t/> }
            elsif @modules[1] eq "install" {
                pandainstall(@modules[2]) }
            }
        elsif @modules[0] eq "module" {
            if @modules[1] eq "list" {
                my $pandadir = %*CUSTOM_LIB<site> ~ '/panda';
                list(panda => Panda.new(
                    srcdir       => "$pandadir/src",
                    destdir      =>  $destdir,
                    statefile    => "$pandadir/state",
                    projectsfile => "$pandadir/projects.json"
                    )) }
            elsif @modules[1] eq "rebuild" {
                rebuild() }
            }
        else {
            if $debug {
                say 'we expect to get: ';
                for @modules -> $m { say " --> $m"; };
                }
            my $pandadir = %*CUSTOM_LIB<site> ~ '/panda';
            projectinfo(Panda.new(
                srcdir       => "$pandadir/src",
                destdir      =>  $destdir,
                statefile    => "$pandadir/state",
                projectsfile => "$pandadir/projects.json"
                ), @modules, $debug);
```
