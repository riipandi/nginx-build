include ../version.mk

# Package name
PKG_NAME=zlib

# PPA version
# PPA_VERSION=1

all:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/zlib-${ZLIB_VERSION} ]; then rm -fr pkgsrc/zlib-${ZLIB_VERSION} ; fi
	@curl -fsSL http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz | tar -zxvf- -C pkgsrc
	@cd pkgsrc/zlib-${ZLIB_VERSION} && ./configure && make && make install

clean:
	@echo 'Clean working dir..'
	@rm -fr pkgsrc
