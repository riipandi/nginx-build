include ../version.mk

# Package name
PKG_NAME=nginx

# PPA version
# PPA_VERSION=1

all:
	@echo "Available commands:"
	@for command in ${COMMANDS}; do echo "  $$command"; done

distro:
	@echo "task distro"

source-build:
	@echo "current nginx version: ${NGX_VERSION}"
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/nginx-${NGX_VERSION} ]; then rm -fr pkgsrc/nginx-${NGX_VERSION} ; fi

build:
	@echo "task build"

install:
	@echo "task install"

dput:
	@echo "task dput"

clean:
	@rm -fr pkgsrc
