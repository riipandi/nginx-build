# Available make command
# ------------------------------------------------------------------------------
COMMANDS = distro source-build build install dput clean

# PPA archive
# ------------------------------------------------------------------------------
PPA_NAME=ppa:riipandi/nginx

# List of target distributions
# ------------------------------------------------------------------------------
DISTROS = xenial bionic

# Debuild command
# ------------------------------------------------------------------------------
DEBUILD=debuild -S

# Packages version
# ------------------------------------------------------------------------------
PERL_VERSION="5.26.1"

PCRE_VERSION="8.43"

ZLIB_VERSION="1.2.11"

OPENSSL_VERSION="1.1.1d"

MAXMIND_VERSION=$(shell echo `curl -s "https://api.github.com/repos/maxmind/libmaxminddb/releases/latest" | jq -r '.tag_name'` | cut -d '-' -f 2)

NGX_VERSION=$(shell echo `curl -s "https://api.github.com/repos/nginx/nginx/tags" | jq -r '.[0].name'` | cut -d '-' -f 2)

NGX_FANCYINDEX=$(shell echo `curl -s "https://api.github.com/repos/aperezdc/ngx-fancyindex/releases/latest" | jq -r '.tag_name'` | cut -d 'v' -f 2)

# Nginx user and group name
# ------------------------------------------------------------------------------
NGX_USER="www-data"
NGX_GROUP="www-data"
