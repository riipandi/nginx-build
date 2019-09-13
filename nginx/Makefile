include ../version.mk

# Package name
PKG_NAME=nginx

# PPA version
# PPA_VERSION=1

all: source-build build install

source-build:
	@echo 'task: source-build'
	@echo "current nginx version: ${NGX_VERSION}"
	@if [ ! -d pkgsrc ]; then mkdir -p pkgsrc ; fi
	@if [ -d pkgsrc/nginx-${NGX_VERSION} ]; then rm -fr pkgsrc/nginx-${NGX_VERSION} ; fi

build:
	@echo 'task: build'

install: build
	@echo 'task: install'
	@# sudo dpkg -i work/*.deb

clean:
	@echo 'Clean working dir..'
	@rm -fr pkgsrc
