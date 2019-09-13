include ../packaging.mk

# Package name
PKG_NAME=openssl

# PPA version
# PPA_VERSION=1

# Debuild command
DEBUILD=debuild -S

all:
	@echo "Available commands:"
	@for command in ${COMMANDS}; do echo "  $$command"; done

distro:
	@echo "task distro"

compile:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/openssl-${OPENSSL_VERSION} ]; then rm -fr pkgsrc/openssl-${OPENSSL_VERSION} ; fi
	@curl -fsSL https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar -zxvf- -C pkgsrc
	@cd pkgsrc/openssl-${OPENSSL_VERSION} \
		&& ./Configure linux-x86_64 --prefix=/usr --openssldir=/usr/lib/ssl shared \
		&& make

install-source:
	@cd pkgsrc/openssl-${OPENSSL_VERSION} \
		&& make install \
		&& echo '/usr/lib' > /etc/ld.so.conf.d/openssl.conf \
		&& ldconfig && openssl version -a

build:
	@echo "task build"

build-source:
	@echo "task build-source"

install:
	@make install
	@echo '/usr/lib' > /etc/ld.so.conf.d/openssl.conf
	@ldconfig && openssl version -a

dput:
	@echo "task dput"

clean:
	@rm -fr pkgsrc
