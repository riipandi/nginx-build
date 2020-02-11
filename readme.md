# PPA Nginx

[![pipeline status](https://github.com/riipandi/ppa-nginx/badges/master/pipeline.svg)](https://github.com/riipandi/ppa-nginx/commits/master)
[![coverage report](https://github.com/riipandi/ppa-nginx/badges/master/coverage.svg)](https://github.com/riipandi/ppa-nginx/commits/master)

PPA sources for Nginx Mainline with additional modules.

## Usage

### Install requirements

```sh
sudo apt update && sudo apt -y install software-properties-common apt-transport-https
sudo add-apt-repository -y ppa:maxmind/ppa && sudo apt -y upgrade
sudo apt -y full-upgrade && sudo apt -y autoremove

sudo apt -y install software-properties-common nano openssl crudini elinks pwgen dirmngr \
gnupg debconf-utils gcc make cmake pv binutils dnsutils bsdtar lsof curl tar zip unzip \
git jq rename mmv dpkg-dev build-essential dh-systemd diffstat quilt tree perl autoconf \
checkinstall ca-certificates mmdb-bin gnupg2 devscripts debhelper dh-make zlib1g zlib1g-dev \
automake libtool uuid-dev lsb-release libpcre3 libpcre3-dev libperl-dev libgd3 libgd-dev \
libssl-dev libxml2 libxml2-dev libgeoip1 libgeoip-dev libxslt1.1 libxslt1-dev geoip-bin \
xutils-dev libtemplate-perl libatomic-ops-dev libmaxminddb0 libmaxminddb-dev
```

### Get the sources

```sh
# Prepare working directory
mkdir -p ~/hatta/{config,htdocs,modules,patches,sources}

# Nginx source
curl -s https://nginx.org/download/nginx-1.17.8.tar.gz | tar xvz -C ~/hatta/sources
mv ~/hatta/sources/nginx-1.17.8 ~/hatta/sources/nginx

# PCRE source
curl -s https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz | tar xvz -C ~/hatta/sources
mv ~/hatta/sources/pcre-8.43 ~/hatta/sources/pcre

# zlib source
curl -s https://www.zlib.net/zlib-1.2.11.tar.gz | tar xvz -C ~/hatta/sources
mv ~/hatta/sources/zlib-1.2.11 ~/hatta/sources/zlib

# OpenSSL source
curl -s https://www.openssl.org/source/openssl-1.1.1c.tar.gz | tar xvz -C ~/hatta/sources
mv ~/hatta/sources/openssl-1.1.1c ~/hatta/sources/openssl

# libmaxminddb
curl -sL https://github.com/maxmind/libmaxminddb/releases/download/1.4.2/libmaxminddb-1.4.2.tar.gz | tar xvz -C ~/hatta/sources
mv ~/hatta/sources/libmaxminddb-1.4.2 ~/hatta/sources/libmaxminddb

# ngx_brotli module
git clone https://github.com/google/ngx_brotli.git ~/hatta/sources/ngx_brotli
cd ~/hatta/sources/ngx_brotli && git submodule update --init

# ngx_pagespeed module
NPS_VERSION="1.13.35.2-stable"
curl -fsSL https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip | bsdtar -xvf- -C ~/hatta/sources
mv ~/hatta/sources/incubator-pagespeed-ngx-${NPS_VERSION} ~/hatta/sources/ngx_pagespeed
cd ~/hatta/sources/ngx_pagespeed
NPS_RELEASE_NUMBER=${NPS_VERSION/beta/}
NPS_RELEASE_NUMBER=${NPS_VERSION/stable/}
psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz
chmod +x scripts/format_binary_url.sh && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
curl -s ${psol_url} | tar xvz -C ~/hatta/sources/ngx_pagespeed

# ngx_rtmp module
git clone https://github.com/arut/nginx-rtmp-module ~/hatta/sources/ngx_rtmp

# ngx_fancyindex
curl -sL https://github.com/aperezdc/ngx-fancyindex/archive/v0.4.3.tar.gz | tar xvz -C ~/hatta/sources
mv ~/hatta/sources/ngx-fancyindex-0.4.3 ~/hatta/sources/ngx_fancyindex
```

### Compile Nginx

```sh
# Create NGINX system group and user
[[ $(cat /etc/group  | grep -c webmaster) -eq 1 ]] || sudo groupadd -g 5000 webmaster
[[ $(cat /etc/passwd | grep -c webmaster) -eq 1 ]] || sudo useradd -u 5000 -s /usr/sbin/nologin -d /bin/null -g webmaster webmaster

# Configure and install
cd ~/hatta/sources/nginx
./configure --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/var/run/nginx/nginx.pid \
    --lock-path=/var/run/nginx/nginx.lock \
    --user=webmaster \
    --group=webmaster \
    --build=altarisdev \
    --builddir=output \
    --with-select_module \
    --with-poll_module \
    --with-threads \
    --with-file-aio \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_xslt_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_geoip_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_auth_request_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_degradation_module \
    --with-http_slice_module \
    --with-http_stub_status_module \
    --with-http_perl_module=dynamic \
    --with-perl_modules_path=/usr/share/perl/5.26.1 \
    --with-perl=/usr/bin/perl \
    --http-log-path=/var/log/nginx/access.log \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --with-mail=dynamic \
    --with-mail_ssl_module \
    --with-stream=dynamic \
    --with-stream_ssl_module \
    --with-stream_realip_module \
    --with-stream_geoip_module=dynamic \
    --with-stream_ssl_preread_module \
    --with-compat \
    --with-pcre=../pcre \
    --with-pcre-jit \
    --with-zlib=../zlib \
    --with-openssl=../openssl \
    --with-openssl-opt=no-nextprotoneg \
    --add-module=../ngx_brotli \
    --add-module=../ngx_pagespeed \
    --ad-module=../ngx_fancyindex \
    --add-dynamic-module=../ngx_rtmp
    # --with-debug

make && sudo make install
sudo ln -fs /usr/lib/nginx/modules /etc/nginx/modules

# Create NGINX directories and set proper permissions
sudo mkdir -p /var/log/nginx /var/run/nginx /etc/nginx/{conf.d,server.d,vhost.d} /var/www
sudo mkdir -p /var/cache/nginx/{client_temp,fastcgi_temp,proxy_temp,scgi_temp,uwsgi_temp}
sudo chmod 700 /var/cache/nginx/* && sudo chown webmaster:root /var/cache/nginx/*
sudo chmod 640 /var/log/nginx/* && sudo chown webmaster:root /var/log/nginx/*
sudo chmod 700 /var/run/nginx/* && sudo chown webmaster:root /var/run/nginx/*
sudo cp -R /etc/nginx/html /var/www && sudo rm -fr /etc/nginx/{html,*.default}
sudo chmod 775 /var/www/html && sudo chown webmaster:webmaster /var/www/html
sudo sed -i "s/html;/\/var\/www\/html;/" /etc/nginx/nginx.conf
sudo nginx -t
```

### Systemd unit file

```sh
sudo tee /etc/systemd/system/nginx.service >/dev/null <<'EOF'
[Unit]
Description=nginx - high performance web server
Documentation=https://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
ExecStartPost=/bin/sleep 0.1
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl is-enabled nginx

sudo systemctl restart nginx
sudo systemctl status nginx
netstat -pltn | grep 80
```

### Create logrotation config for NGINX

```sh
sudo tee /etc/logrotate.d/nginx >/dev/null <<'EOF'
/var/log/nginx/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 640 webmaster webmaster
    sharedscripts
    postrotate
        if [ -f /var/run/nginx/nginx.pid ]; then
            kill -USR1 `cat /var/run/nginx/nginx.pid`
        fi
    endscript
}
EOF
```

<!--
### Rebranding

```sh
cd ~/hatta/sources
find . -type f -exec rename -f 's/ngx/htt/' * {} \;
find . -type f -exec rename -f 's/nginx/hatta/' * {} \;
find . -type d -exec rename -f 's/nginx/hatta/' * {} \;
find . -type d -exec rename -f 's/ngx/htt/' * {} \;
find . -type f -exec sed -i 's/Nginx/Hatta/g' {} \;
find . -type f -exec sed -i 's/nginx/hatta/g' {} \;
find . -type f -exec sed -i 's/ngx/htt/g' {} \;
find . -type f -exec sed -i 's/hatta.org/hatta.github.io/g' {} \;
```
-->

### Compile OpenSSL

```sh
# Determine OpenSSL version
openssl version -a ; openssl version -d

# Configure and install
curl -L# 'http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0x7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C' -o levitte.txt
curl -L# 'http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0x8657ABB260F056B1E5190839D9C4D26D0E604491' -o caswell.txt
gpg --import caswell.txt && gpg --import levitte.txt && gpg --list-keys
for fpr in $(gpg --list-keys --with-colons | awk -F: '/fpr:/ {print $10}' | sort -u); do  echo -e "5\ny\n" |  gpg --command-fd 0 --expert --edit-key $fpr trust; done

cd ~/hatta/sources/openssl
# ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
./config --prefix=/usr/lib --openssldir=/usr/lib/ssl shared zlib
make && make test
sudo make install

echo '/usr/local/ssl/lib' | sudo tee /etc/ld.so.conf.d/openssl-1.1.1c.conf
sudo ldconfig -v
```

### Compile libmaxminddb

```sh
cd ~/hatta/sources/libmaxminddb
./configure
make && make check
sudo make install
sudo ldconfig

# If got error that libmaxminddb.so.0 is missing
sudo sh -c "echo /usr/local/lib  >> /etc/ld.so.conf.d/local.conf"
ldconfig
```

## About

This branch follows latest NGINX Mainline packages compiled against latest OpenSSL for HTTP/2,
TLS 1.3 support, Brotli, and some additional modules.

BUGS & FEATURES: <https://github.com/riipandi/ppa-nginx/issues>

> If you like my work, you can give me a little motivation by donating via: <https://paypal.me/riipandi>

### References

- https://github.com/named-data/ppa-packaging
