# PPA Nginx

[![pipeline status](https://gitlab.com/riipandi/ppa-nginx/badges/master/pipeline.svg)](https://gitlab.com/riipandi/ppa-nginx/commits/master)
[![coverage report](https://gitlab.com/riipandi/ppa-nginx/badges/master/coverage.svg)](https://gitlab.com/riipandi/ppa-nginx/commits/master)

PPA sources for Nginx Mainline with additional modules.

## Usage

### Install requirements firs

```sh
apt update && apt -y install sudo software-properties-common

add-apt-repository -y ppa:maxmind/ppa && apt -y upgrade

apt -y install curl tar unzip git dpkg-dev build-essential dh-systemd diffstat quilt tree perl \
autoconf checkinstall ca-certificates zlib1g zlib1g-dev libpcre3 libpcre3-dev libperl-dev libgd3 \
libgd-dev libssl-dev automake libtool uuid-dev lsb-release libxml2 libxml2-dev libxslt1.1 \
libxslt1-dev libgeoip1 libgeoip-dev geoip-bin xutils-dev libtemplate-perl libatomic-ops-dev
```

## About

This branch follows latest NGINX Mainline packages compiled against latest OpenSSL for HTTP/2, TLS 1.3 support, Brotli, and some additional modules.

BUGS & FEATURES: <https://gitlab.com/riipandi/ppa-nginx/issues>

> If you like my work, you can give me a little motivation by donating via: <https://paypal.me/riipandi>

### References

- https://github.com/named-data/ppa-packaging
