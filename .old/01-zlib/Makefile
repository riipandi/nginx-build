include ../packaging.mk

# Package name
PKG_NAME=zlib

# PPA version
# PPA_VERSION=1

all:
	@echo "Available commands:"
	@for command in ${COMMANDS}; do echo "  $$command"; done

distro:
	@echo "task distro"

compile:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/zlib-${ZLIB_VERSION} ]; then rm -fr pkgsrc/zlib-${ZLIB_VERSION} ; fi
	@curl -fsSL http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz | tar -zxvf- -C pkgsrc
	@cd pkgsrc/zlib-${ZLIB_VERSION} && ./configure && make

install-source:
	@cd pkgsrc/zlib-${ZLIB_VERSION} && make install

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
