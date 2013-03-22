use v6;

use Shell::Command;
use Panda;

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

inherit git-2 ufo

DESCRIPTION="$description"
HOMEPAGE="https://perl6.org/"
EGIT_REPO_URI="$git"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"
}
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

sub projectinfo($panda, @args, $debug) is export {
    for @args -> $p {
        my $x = $panda.ecosystem.get-project($p);
        $x = $panda.project-from-local($p) unless $x;
        if $x {
            my $state = $panda.ecosystem.project-get-state($x);
            say 'making ebuild for:';
            say $x.name => $x.version;
            if $debug {
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
                say '';
                }
            #NOT READY, NEED NAME FORMATING, DEPENDIES PROCESS AND SOME MORE BUT ALREADY CAN WALK
            my $filename = $x.name ~ '-' ~ ( $x.version eq "*" ?? '9999' !! $x.version ) ~ '.ebuild';
            my $ebuild = $filename eq '-' ?? $*OUT !! open $filename, :w;
            $ebuild.print(
                ebuild_template()\
                    .subst(/^\n/, '')\
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
