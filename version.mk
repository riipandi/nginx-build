# Make command
COMMANDS = distro source-build build install dput clean

# Packages version

PERL_VERSION="5.26.1"

PCRE_VERSION="8.43"

ZLIB_VERSION="1.2.11"

OPENSSL_VERSION="1.1.1d"

MAXMIND_VERSION=$(shell echo `curl -s "https://api.github.com/repos/maxmind/libmaxminddb/releases/latest" | jq -r '.tag_name'` | cut -d '-' -f 2)

NGX_VERSION=$(shell echo `curl -s "https://api.github.com/repos/nginx/nginx/tags" | jq -r '.[0].name'` | cut -d '-' -f 2)
NGX_FANCYINDEX="0.4.3"
NGX_USER="www-data"
NGX_GROUP="www-data"
