#!/bin/bash
if [[ $EUID -ne 0 ]]; then echo 'You must be root!' ; exit 1 ; fi

# Version variables
# --------------------------------------------------------------------------------------------------------
# CURRENT_BASEDIR=$(dirname "$(readlink -f "$0")")
CURRENT_BASEDIR=$(pwd)

PERL_VERSION="5.26.1"
PCRE_VERSION="8.43"
ZLIB_VERSION="1.2.11"
OPENSSL_VERSION="1.1.1d"

NGX_FANCYINDEX="0.4.3"
NGX_USER="www-data"
NGX_GROUP="www-data"

# Build dependencies
# --------------------------------------------------------------------------------------------------------
add-apt-repository -y ppa:maxmind/ppa && apt update && apt -y upgrade
apt -y install curl tar unzip git dpkg-dev build-essential zlib1g zlib1g-dev libpcre3 libpcre3-dev \
dh-systemd diffstat quilt tree perl libperl-dev libgd3 libgd-dev libssl-dev ca-certificates \
autoconf automake libtool uuid-dev lsb-release libgeoip1 libgeoip-dev geoip-bin libxml2 \
libxml2-dev libxslt1.1 libxslt1-dev xutils-dev checkinstall libtemplate-perl libatomic-ops-dev

# nginx dependencies
# https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
# --------------------------------------------------------------------------------------------------------

# Perl
[[ ! -d /usr/src/perl-${PERL_VERSION} ]] || rm -fr /usr/src/perl-${PERL_VERSION}
curl -fsSL http://www.cpan.org/src/5.0/perl-${PERL_VERSION}.tar.gz | tar -zxvf- -C /usr/src
# cd /usr/src/perl-${PERL_VERSION} && ./Configure -des -Dprefix=/usr -Dusethreads
# make && make test && make install

# PCRE
[[ ! -d /usr/src/pcre-${PCRE_VERSION} ]] || rm -fr /usr/src/pcre-${PCRE_VERSION}
curl -fsSL https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz | tar -zxvf- -C /usr/src
cd /usr/src/pcre-${PCRE_VERSION} && ./configure && make && make install

# zlib
[[ ! -d /usr/src/zlib-${ZLIB_VERSION} ]] || rm -fr /usr/src/zlib-${ZLIB_VERSION}
curl -fsSL http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz | tar -zxvf- -C /usr/src
cd /usr/src/zlib-${ZLIB_VERSION} && ./configure && make && make install

# OpenSSL
[[ ! -d /usr/src/openssl-${OPENSSL_VERSION} ]] || rm -fr /usr/src/openssl-${OPENSSL_VERSION}
curl -fsSL https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar -zxvf- -C /usr/src
cd /usr/src/openssl-${OPENSSL_VERSION} && ./Configure linux-x86_64 --prefix=/usr --openssldir=/usr/lib/ssl shared
make && make install && echo '/usr/lib' > /etc/ld.so.conf.d/openssl.conf && sudo ldconfig
openssl version -a

# nginx additional modules
# --------------------------------------------------------------------------------------------------------

# libmaxminddb
MAXMIND_RELEASE=$(curl -s "https://api.github.com/repos/maxmind/libmaxminddb/releases/latest" | jq -r '.tag_name')
MAXMIND_VERSION=$(echo ${MAXMIND_RELEASE} | cut -d '-' -f 2)
[[ ! -d /usr/src/libmaxminddb-${MAXMIND_VERSION} ]] || rm -fr /usr/src/libmaxminddb-${MAXMIND_VERSION}
curl -fsSL https://github.com/maxmind/libmaxminddb/releases/download/${MAXMIND_VERSION}/libmaxminddb-${MAXMIND_VERSION}.tar.gz | tar -zxvf- -C /usr/src
cd /usr/src/libmaxminddb-${MAXMIND_VERSION} && ./configure && make && make check && make install && ldconfig

# Brotli
[[ ! -d /usr/src/ngx_brotli ]] || rm -fr /usr/src/ngx_brotli
git clone https://github.com/google/ngx_brotli.git /usr/src/ngx_brotli
cd /usr/src/ngx_brotli && git submodule update --init

# FancyIndex
[[ ! -d /usr/src/ngx-fancyindex-${NGX_FANCYINDEX} ]] || rm -fr /usr/src/ngx-fancyindex-${NGX_FANCYINDEX}
curl -fsSL https://github.com/aperezdc/ngx-fancyindex/archive/v{$NGX_FANCYINDEX}.tar.gz | tar -zxvf- -C /usr/src

# Nginx RTMP
# ngx_rtmp_release=$(curl -s "https://api.github.com/repos/sergey-dryabzhinsky/nginx-rtmp-module/tags" | jq -r '.[0].name')
# ngx_rtmp_version=$(echo ${ngx_rtmp_release} | cut -d 'v' -f 2)
# curl -fsSL https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/${ngx_rtmp_release}.tar.gz | tar -zxvf- -C /usr/src

# PageSpeed
MODPAGESPEED_RELEASE=$(curl -s "https://api.github.com/repos/apache/incubator-pagespeed-ngx/tags" | jq -r '.[0].name')
MODPAGESPEED_VERSION=$(echo ${MODPAGESPEED_RELEASE} | cut -d 'v' -f 2)
PSOL_RELEASE_NUMBER=${MODPAGESPEED_VERSION/stable/}

[[ ! -d /usr/src/incubator-pagespeed-ngx-${MODPAGESPEED_VERSION} ]] || rm -fr /usr/src/incubator-pagespeed-ngx-${MODPAGESPEED_VERSION}
curl -fsSL https://github.com/apache/incubator-pagespeed-ngx/archive/${MODPAGESPEED_RELEASE}.tar.gz | tar -zxvf- -C /usr/src
cd /usr/src/incubator-pagespeed-ngx-${MODPAGESPEED_VERSION}
curl -fsSL https://dl.google.com/dl/page-speed/psol/${PSOL_RELEASE_NUMBER}x$(uname -p | cut -d '_' -f 2).tar.gz | tar -zxvf-

# Download nginx source
# --------------------------------------------------------------------------------------------------------
NGX_RELEASE=$(curl -s "https://api.github.com/repos/nginx/nginx/tags" | jq -r '.[0].name')
NGX_VERSION=$(echo ${NGX_RELEASE} | cut -d '-' -f 2)

[[ ! -d /usr/src/nginx-${NGX_VERSION} ]] || rm -fr /usr/src/nginx-${NGX_VERSION}
curl -fsSL http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz | tar -zxvf- -C /usr/src
cd /usr/src/nginx-${NGX_VERSION}

# Customize Nginx
# --------------------------------------------------------------------------------------------------------
# find . -depth -name '*nginx*' -execdir bash -c 'for f; do mv -i "$f" "${f//nginx/servant}"; done' bash {} +
# find . -depth -name '*ngx_*' -execdir bash -c 'for f; do mv -i "$f" "${f//ngx_/svt_}"; done' bash {} +
# egrep -lRZ 'Nginx' . | xargs -0 -l sed -i -e 's/Nginx/Servant/g'
# egrep -lRZ 'nginx' . | xargs -0 -l sed -i -e 's/nginx/servant/g'
# egrep -lRZ 'NGINX' . | xargs -0 -l sed -i -e 's/NGINX/SERVANT/g'
# egrep -lRZ 'ngx_' . | xargs -0 -l sed -i -e 's/ngx_/svt_/g'
# egrep -lRZ 'NGX_' . | xargs -0 -l sed -i -e 's/NGX_/SVT_/g'
# ==========================================================================================
# sed -i "s/\"Server: nginx\"/\"Server: servant\"/" src/http/ngx_http_header_filter_module.c
# sed -i "s/\"nginx\/\"/\"servant\/\"/" src/core/nginx.h
# sed -i "s/nobody/www-data/" conf/nginx.conf
# sed -i "s/#user/user/" conf/nginx.conf
# curl -sL https://git.io/Jemb4 -o html/index.html
# curl -sL https://git.io/JembB -o html/404.html
# sed -i "s/nginx/servant/" html/50x.html
# ==========================================================================================

rm -fr /usr/src/nginx-${NGX_VERSION}/conf/*
rm -fr /usr/src/nginx-${NGX_VERSION}/html/*
cp -r $CURRENT_BASEDIR/stubs/conf/* /usr/src/nginx-${NGX_VERSION}/conf/.
cp -r $CURRENT_BASEDIR/stubs/html/* /usr/src/nginx-${NGX_VERSION}/html/.

# Compile Nginx
# groupadd -g 3000 webmaster && useradd -u 3000 -s /usr/sbin/nologin -d /bin/null -g webmaster webmaster
# --------------------------------------------------------------------------------------------------------
NO_WARNING_CHECKS=yes ./configure \
    --prefix=/usr/share/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --user=${NGX_USER} --group=${NGX_GROUP} \
    --build=$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed 's/\"//g') \
    --builddir=build-${NGX_VERSION} \
    --http-log-path=/var/log/nginx/access.log \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --with-compat \
    --with-cc-opt="-O3" \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_degradation_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_perl_module=dynamic \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-openssl=/usr/src/openssl-${OPENSSL_VERSION} \
    --with-openssl-opt=enable-ec_nistp_64_gcc_128 \
    --with-openssl-opt=no-nextprotoneg \
    --with-openssl-opt=no-ssl3 \
    --with-openssl-opt=no-weak-ssl-ciphers \
    --with-pcre-jit \
    --with-pcre=/usr/src/pcre-${PCRE_VERSION} \
    --with-perl_modules_path=/usr/src/perl-${PERL_VERSION} \
    --with-perl=/usr/bin/perl \
    --with-poll_module \
    --with-select_module \
    --with-stream_geoip_module=dynamic \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream=dynamic \
    --with-threads \
    --with-zlib=/usr/src/zlib-${ZLIB_VERSION} \
    --add-module=/usr/src/ngx-fancyindex-${NGX_FANCYINDEX} \
    --add-dynamic-module=/usr/src/ngx_brotli \
    --add-dynamic-module=/usr/src/incubator-pagespeed-ngx-${MODPAGESPEED_VERSION}
    # --add-dynamic-module=/usr/src/nginx-rtmp-module-${ngx_rtmp_version}

make && make install && mkdir -p /var/cache/nginx

echo -e '\nCompilation process has finished..\n'
