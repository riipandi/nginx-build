include ../version.mk

# Package name
PKG_NAME=pcre

# PPA version
# PPA_VERSION=1

all:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/pcre-${PCRE_VERSION} ]; then rm -fr pkgsrc/pcre-${PCRE_VERSION} ; fi
	@curl -fsSL https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz | tar -zxvf- -C pkgsrc
	@cd pkgsrc/pcre-${PCRE_VERSION} && ./configure && make && make install

clean:
	@echo 'Clean working dir..'
	@rm -fr pkgsrc
