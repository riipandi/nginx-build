include ../packaging.mk

# Package name
PKG_NAME=perl

# PPA version
# PPA_VERSION=1

all:
	@echo "Available commands:"
	@for command in ${COMMANDS}; do echo "  $$command"; done

distro:
	@echo "task distro"

compile:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/perl-${PERL_VERSION} ]; then rm -fr pkgsrc/perl-${PERL_VERSION} ; fi
	@curl -fsSL http://www.cpan.org/src/5.0/perl-${PERL_VERSION}.tar.gz | tar -zxvf- -C pkgsrc
	@cd pkgsrc/perl-${PERL_VERSION} && ./Configure -des -Dprefix=/usr -Dusethreads
	@make && make test

install-source:
	@cd pkgsrc/perl-${PERL_VERSION} && make install

build:
	@echo "task build"

build-source:
	@echo "task build-source"

install:
	@make install

dput:
	@echo "task dput"

clean:
	@rm -fr pkgsrc
