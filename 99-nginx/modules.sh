#!/bin/bash
if [[ $EUID -ne 0 ]]; then echo 'You must be root!' ; exit 1 ; fi

source ../version.mk

# nginx additional modules
# --------------------------------------------------------------------------------------------------------

# Brotli
[[ ! -d $PWD/packages/ngx_brotli ]] || rm -fr $PWD/packages/ngx_brotli
git clone https://github.com/google/ngx_brotli.git $PWD/packages/ngx_brotli
cd $PWD/packages/ngx_brotli && git submodule update --init

# FancyIndex
[[ ! -d $PWD/packages/ngx-fancyindex-${NGX_FANCYINDEX} ]] || rm -fr $PWD/packages/ngx-fancyindex-${NGX_FANCYINDEX}
curl -fsSL https://github.com/aperezdc/ngx-fancyindex/archive/v{$NGX_FANCYINDEX}.tar.gz | tar -zxvf- -C $PWD/packages

# Nginx RTMP
# ngx_rtmp_release=$(curl -s "https://api.github.com/repos/sergey-dryabzhinsky/nginx-rtmp-module/tags" | jq -r '.[0].name')
# ngx_rtmp_version=$(echo ${ngx_rtmp_release} | cut -d 'v' -f 2)
# curl -fsSL https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/${ngx_rtmp_release}.tar.gz | tar -zxvf- -C $PWD/packages

# PageSpeed
MODPAGESPEED_RELEASE=$(curl -s "https://api.github.com/repos/apache/incubator-pagespeed-ngx/tags" | jq -r '.[0].name')
MODPAGESPEED_VERSION=$(echo ${MODPAGESPEED_RELEASE} | cut -d 'v' -f 2)
PSOL_RELEASE_NUMBER=${MODPAGESPEED_VERSION/stable/}

[[ ! -d $PWD/packages/incubator-pagespeed-ngx-${MODPAGESPEED_VERSION} ]] || rm -fr $PWD/packages/incubator-pagespeed-ngx-${MODPAGESPEED_VERSION}
curl -fsSL https://github.com/apache/incubator-pagespeed-ngx/archive/${MODPAGESPEED_RELEASE}.tar.gz | tar -zxvf- -C $PWD/packages
cd $PWD/packages/incubator-pagespeed-ngx-${MODPAGESPEED_VERSION}
curl -fsSL https://dl.google.com/dl/page-speed/psol/${PSOL_RELEASE_NUMBER}x$(uname -p | cut -d '_' -f 2).tar.gz | tar -zxvf-
