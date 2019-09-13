include ./version.mk

DIRS = $(filter %/, $(wildcard */))

all:
	@echo "Available commands:"
	@for command in ${COMMANDS}; do echo "  $$command"; done

# dep:
# 	@apt update && apt -y install sudo software-properties-common
# 	@add-apt-repository -y ppa:maxmind/ppa && apt -y upgrade
# 	@apt -y install curl tar unzip git dpkg-dev build-essential zlib1g zlib1g-dev libpcre3 libpcre3-dev \
# 		dh-systemd diffstat quilt tree perl libperl-dev libgd3 libgd-dev libssl-dev ca-certificates \
# 		autoconf automake libtool uuid-dev lsb-release libgeoip1 libgeoip-dev geoip-bin libxml2 \
# 		libxml2-dev libxslt1.1 libxslt1-dev xutils-dev checkinstall libtemplate-perl libatomic-ops-dev
# .PHONY: dep

$(COMMANDS): ${DIRS}
	@for dir in ${DIRS}; do (cd $$dir && $(MAKE) $@) ; done
