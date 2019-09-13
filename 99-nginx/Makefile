include ../packaging.mk

# Package name
PKG_NAME=nginx

# PPA version
# PPA_VERSION=1

all:
	@echo "Available commands:"
	@for command in ${COMMANDS}; do echo "  $$command"; done

distro:
	@echo "task distro"

compile:
	@echo "current nginx version: ${NGX_VERSION}"
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/nginx-${NGX_VERSION} ]; then rm -fr pkgsrc/nginx-${NGX_VERSION} ; fi

install-source:
	@cd /usr/src/nginx-${NGX_VERSION} \
		&& make install \
		&& mkdir -p /var/cache/nginx

build:
	@echo "task build"

build-source:
	@echo "task build-source"
install:
	@echo "task install"

dput:
	@echo "task dput"

clean:
	@rm -fr pkgsrc
