Crystal Maiden
==============

 - Generate ebuilds for perl6 modules using data from ecosystem
 - Process code compilation / testing / installation via eclass
 - use gentoo-perl6 overlay.

``` perl
sub help() {
    say '
    Crystal Maiden for Perl6

      - use cm help to get this message
      - READ THE CODE
    ';
    }
sub MAIN(*@modules, Bool :$debug = False, Bool :$help = False) {
    my $pandadir = %*CUSTOM_LIB<site> ~ '/panda';
    my $panda = Panda.new(
        srcdir       => "$pandadir/src",
        destdir      =>  $destdir,
        statefile    => "$pandadir/state",
        projectsfile => "$pandadir/projects.json"
        );
    if $help { help() }
    else {
        if !@modules { list(panda => $panda) }
        elsif @modules[0] eq "src_configure" {
            src_configure() }
        elsif @modules[0] eq "src_compile" {
            pandacompile()
            }
        elsif @modules[0] eq "src_test" {
            run <prove -e perl6 -r t/>
            }
        elsif @modules[0] eq "src_install" {
            pandainstall(@modules[1])
            }
        else {
            if $debug {
                say 'we expect to get: ';
                for @modules -> $m { say " --> $m"; };
                }
            projectinfo($panda, @modules, $debug);
            }
        }
    }
```
