include ../packaging.mk

# Package name
PKG_NAME=libmaxminddb

# PPA version
# PPA_VERSION=1

all:
	@echo "Available commands:"
	@for command in ${COMMANDS}; do echo "  $$command"; done

distro:
	@echo "task distro"

compile:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/libmaxminddb-${MAXMIND_VERSION} ]; then rm -fr pkgsrc/libmaxminddb-${MAXMIND_VERSION} ; fi
	@curl -fsSL https://github.com/maxmind/libmaxminddb/releases/download/${MAXMIND_VERSION}/libmaxminddb-${MAXMIND_VERSION}.tar.gz | tar -zxvf- -C pkgsrc
	@cd pkgsrc/libmaxminddb-${MAXMIND_VERSION} && ./configure && make && make check

install-source:
	@cd /usr/src/libmaxminddb-${MAXMIND_VERSION} && make install && ldconfig

build:
	@echo "task build"

build-source:
	@echo "task build-source"

install:
	@make install && ldconfig

dput:
	@echo "task dput"

clean:
	@rm -fr pkgsrc
