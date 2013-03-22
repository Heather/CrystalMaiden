Crystal Maiden
==============

 - work in progress

``` shell
>>PERL6LIB=lib ./bin/cm --debug ufo
we expect to get: 
 --> ufo
making ebuild for:
"ufo" => "*"
"Source-url" => "git://github.com/masak/ufo.git"
"Description" => "Swoops down and creates your Perl 6 project Makefile for you"

>>cat ufo-9999.ebuild
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit git-2 ufo

DESCRIPTION="Swoops down and creates your Perl 6 project Makefile for you"
HOMEPAGE="https://perl6.org/"
EGIT_REPO_URI="git://github.com/masak/ufo.git"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"
```
