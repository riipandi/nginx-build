include ../packaging.mk

# Package name
PKG_NAME=pcre

# PPA version
# PPA_VERSION=1

all:
	@echo "Available commands:"
	@for command in ${COMMANDS}; do echo "  $$command"; done

distro:
	@echo "task distro"

compile:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/pcre-${PCRE_VERSION} ]; then rm -fr pkgsrc/pcre-${PCRE_VERSION} ; fi
	@curl -fsSL https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz | tar -zxvf- -C pkgsrc
	@cd pkgsrc/pcre-${PCRE_VERSION} && ./configure && make

install-source:
	@cd pkgsrc/pcre-${PCRE_VERSION} && make install

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
