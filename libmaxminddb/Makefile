include ../version.mk

# Package name
PKG_NAME=libmaxminddb

# PPA version
# PPA_VERSION=1

all:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/libmaxminddb-${MAXMIND_VERSION} ]; then rm -fr pkgsrc/libmaxminddb-${MAXMIND_VERSION} ; fi
	@curl -fsSL https://github.com/maxmind/libmaxminddb/releases/download/${MAXMIND_VERSION}/libmaxminddb-${MAXMIND_VERSION}.tar.gz | tar -zxvf- -C $PWD/packages
	@cd $PWD/packages/libmaxminddb-${MAXMIND_VERSION} && ./configure && make && make check
	@make install && ldconfig

clean:
	@echo 'Clean working dir..'
	@rm -fr pkgsrc
