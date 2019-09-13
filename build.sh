#!/bin/bash
if [[ $EUID -ne 0 ]]; then echo 'You must be root!' ; exit 1 ; fi

# Version variables
# --------------------------------------------------------------------------------------------------------
PWD=$(pwd)

PERL_VERSION="5.26.1"
PCRE_VERSION="8.43"
ZLIB_VERSION="1.2.11"
OPENSSL_VERSION="1.1.1d"
MAXMIND_VERSION=$(echo `curl -s "https://api.github.com/repos/maxmind/libmaxminddb/releases/latest" | jq -r '.tag_name'` | cut -d '-' -f 2)

NGX_VERSION=$(echo `curl -s "https://api.github.com/repos/nginx/nginx/tags" | jq -r '.[0].name'` | cut -d '-' -f 2)
NGX_FANCYINDEX="0.4.3"
NGX_USER="www-data"
NGX_GROUP="www-data"

[[ ! -d $PWD/packages ]] && mkdir -p $PWD/packages

# nginx additional modules
# --------------------------------------------------------------------------------------------------------

# Download nginx source
# --------------------------------------------------------------------------------------------------------
[[ ! -d $PWD/packages/nginx-${NGX_VERSION} ]] || rm -fr $PWD/packages/nginx-${NGX_VERSION}
curl -fsSL http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz | tar -zxvf- -C $PWD/packages
cd $PWD/packages/nginx-${NGX_VERSION}

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

rm -fr $PWD/packages/nginx-${NGX_VERSION}/conf/*
rm -fr $PWD/packages/nginx-${NGX_VERSION}/html/*
cp -r $PWD/stubs/conf/* $PWD/packages/nginx-${NGX_VERSION}/conf/.
cp -r $PWD/stubs/html/* $PWD/packages/nginx-${NGX_VERSION}/html/.

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
    --with-openssl=$PWD/packages/openssl-${OPENSSL_VERSION} \
    --with-openssl-opt=enable-ec_nistp_64_gcc_128 \
    --with-openssl-opt=no-nextprotoneg \
    --with-openssl-opt=no-ssl3 \
    --with-openssl-opt=no-weak-ssl-ciphers \
    --with-pcre-jit \
    --with-pcre=$PWD/packages/pcre-${PCRE_VERSION} \
    --with-perl_modules_path=$PWD/packages/perl-${PERL_VERSION} \
    --with-perl=/usr/bin/perl \
    --with-poll_module \
    --with-select_module \
    --with-stream_geoip_module=dynamic \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream=dynamic \
    --with-threads \
    --with-zlib=$PWD/packages/zlib-${ZLIB_VERSION} \
    --add-module=$PWD/packages/ngx-fancyindex-${NGX_FANCYINDEX} \
    --add-dynamic-module=$PWD/packages/ngx_brotli \
    --add-dynamic-module=$PWD/packages/incubator-pagespeed-ngx-${MODPAGESPEED_VERSION}
    # --add-dynamic-module=$PWD/packages/nginx-rtmp-module-${ngx_rtmp_version}

make && make install && mkdir -p /var/cache/nginx

echo -e '\nCompilation process has finished..\n'
