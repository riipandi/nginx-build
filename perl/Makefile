include ../version.mk

# Package name
PKG_NAME=perl

# PPA version
# PPA_VERSION=1

all:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/perl-${PERL_VERSION} ]; then rm -fr pkgsrc/perl-${PERL_VERSION} ; fi
	@curl -fsSL http://www.cpan.org/src/5.0/perl-${PERL_VERSION}.tar.gz | tar -zxvf- -C pkgsrc
	@cd pkgsrc/perl-${PERL_VERSION} && ./Configure -des -Dprefix=/usr -Dusethreads
	@make && make test && make install

clean:
	@echo 'Clean working dir..'
	@rm -fr pkgsrc
