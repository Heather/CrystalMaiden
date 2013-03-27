![alt text](http://www.dota2wiki.com/images/2/27/Crystal_Maiden_icon.png "CM") Crystal Maiden
=============================================================================================

 - Generate ebuilds for perl6 modules using data from ecosystem
 - Process code compilation / testing / installation via eclass
 - use gentoo-perl6 overlay.

``` perl
sub MAIN(*@args, Bool :$help = False, Str :$overlay is copy) {
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
                    destdir      =>  'CRYSTAL MAIDEN',
                    statefile    => "$pandadir/state",
                    projectsfile => "$pandadir/projects.json"
                    )) }
            elsif @args[1] eq "rebuild" {
                rebuild() }
            }
        else {
            my $pandadir = %*CUSTOM_LIB<site> ~ '/panda';
            unless $overlay.defined {
                $overlay = '/usr/home/gentoo-perl6'
                }
            projectinfo(Panda.new(
                srcdir       => "$pandadir/src",
                destdir      =>  'CRYSTAL MAIDEN',
                statefile    => "$pandadir/state",
                projectsfile => "$pandadir/projects.json"
                ), $overlay, @args);
```
