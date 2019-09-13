include ../version.mk

# Package name
PKG_NAME=openssl

# PPA version
# PPA_VERSION=1

all:
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/openssl-${OPENSSL_VERSION} ]; then rm -fr pkgsrc/openssl-${OPENSSL_VERSION} ; fi
	@curl -fsSL https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar -zxvf- -C pkgsrc
	@cd pkgsrc/openssl-${OPENSSL_VERSION} && ./Configure linux-x86_64 --prefix=/usr --openssldir=/usr/lib/ssl shared
	@make && make install && echo '/usr/lib' > /etc/ld.so.conf.d/openssl.conf && ldconfig && openssl version -a

clean:
	@echo 'Clean working dir..'
	@rm -fr pkgsrc
