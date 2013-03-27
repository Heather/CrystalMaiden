use v6;

use Shell::Command;
use Panda;
use Panda::Installer;
use Panda::Builder;
use Panda::Resources;

module Crystal::Maiden;

class Crystal::Maiden::Result is Cool {
    has $.panda;
    }

sub ebuild_template() is export {
return q{
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit git-2 crystalmaiden

DESCRIPTION="$description"
HOMEPAGE="$homepage"
EGIT_REPO_URI="$git"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"
}
}

sub printlibpath() is export {
    print %*CUSTOM_LIB<site>
    }

sub list (:$panda!, :$installed) is export {
    my $es        = $panda.ecosystem;
    my @projects  = $es.project-list.sort.map: { $es.get-project($_) };

    my @saved     = @projects.map({ $es.project-get-saved-meta($_) || {} });
    my $max-name  = @projects».name».chars.max;
    my $max-ver   = @projects».version».chars.max;
    my $max-rev   = @saved.map({ $_<source-revision> // '?'})».chars.max;

    for @projects -> $x {
        my $s = do given $es.project-get-state($x) {
            when 'installed'     { '[installed]' }
            when 'installed-dep' { '-dependency-' }
            default              { '' }
            }

        my $meta = $s ?? $es.project-get-saved-meta($x) !! $x.metainfo;
        my $url  = $meta<source-url> // $meta<repo-url> // 'UNKNOWN';
        my $rev  = $meta<source-revision> // '?';
        my $ver  = $meta<version>;

        printf "%-{$max-name}s  %-12s  %-{$max-ver}s  %-{$max-rev}s  %s\n",
            $x.name, $s, $ver, $rev, $url;
            }
    }
 
sub pandacompile() is export {
    my $me = cwd.split('/')[*-1];
    my $srcdir = '..';
    my $r = Panda::Resources.new(srcdir => $srcdir);
    my $b = Panda::Builder.new(resources => $r);
    my $p = Pies::Project.new(name => $me);
    $b.build($p);
    }
 
sub pandainstall($dd) is export {
    my $me = cwd.split('/')[*-1];
    my $srcdir = '..';
    my $destdir = $dd ~ %*CUSTOM_LIB<site>;
    my $r = Panda::Resources.new(srcdir => $srcdir);
    my $b = Panda::Installer.new(resources => $r, destdir => $destdir);
    my $p = Pies::Project.new(name => $me);    
    $b.install($p);
    if ( './bin' ).IO.d {
        say "moving bin files to proper place";
        for dir('./bin') -> $file {
            my $wrong = $destdir ~ '/bin/' ~ $file.basename;
            mkpath $dd ~ '/usr/bin/';
            my $correct = $dd ~ '/usr/bin/' ~ $file.basename;
            run ('mv', $wrong, $correct);
            }
        }
    }

sub projectinfo($panda, $overlay, @args) is export {
    for @args -> $p {
        my $x = $panda.ecosystem.get-project($p);
        $x = $panda.project-from-local($p) unless $x;
        if $x {
            my $state = $panda.ecosystem.project-get-state($x);
            say 'making ebuild for:';
            say $x.name => $x.version;
            say 'Depends on:' => $x.dependencies.Str if $x.dependencies;
            given $state {
                when 'installed'     {
                    say 'State' => 'installed';
                    }
                when 'installed-dep' {
                    say 'State' => 'installed as a dependency';
                    }
                }
            for $x.metainfo.kv -> $k, $v {
                if $k ~~ none('version', 'name', 'depends') {
                    say $k.ucfirst => $v;
                    }
                }
            if $state ~~ /^ 'installed' / {
                say 'INSTALLED VERSION:';
                .say for $panda.ecosystem.project-get-saved-meta($x).pairs.sort;
                }
            my $fnm = ($x.name).subst("::", '').lc;
            my $pth = $overlay ~ '/dev-perl/' ~ $fnm ~ '/';
            mkpath $pth;
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
                    .subst('$git', $x.metainfo{'source-url'})
                );
            $ebuild.close;
            }
        else {
            say "Project '$p' not found"
            }
        }
    }
