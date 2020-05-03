FROM tundrasoft/alpine-base
LABEL maintainer="Abhinav A V<abhai2k@gmail.com>"

ARG NGINX_VERSION=1.18.0
ARG NGINX_DOWNLOAD_URI=https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz 
ARG NGINX_TRAFFIC_MODULE="https://github.com/Lax/traffic-accounting-nginx-module.git"
ARG NGINX_UPLOAD_PROGRESS="https://github.com/masterzen/nginx-upload-progress-module.git"
ARG NGINX_CONFIG="\
  --prefix=/usr/local/nginx \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --pid-path=/var/run/nginx/nginx.pid \
  --error-log-path=/var/logs/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --user=abc \
  --group=abc \
  --with-pcre \
  --with-pcre-jit \
  --with-zlib= \
  --with-http_ssl_module \
  --with-stream=dynamic \
  --with-stream_ssl_module \
  --with-http_addition_module \
  --with-http_dav_module \
  --with-mail=dynamic \
  --with-mail_ssl_module \
  --with-http_stub_status_module \
  --with-http_geoip_module=dynamic \
  --with-http_sub_module \
  --add-dynamic-module=traffic-accounting-nginx-module \
  --add-dynamic-module=nginx-upload-progress-module \
  "

RUN apk add --no-cache \
  pcre \
  zlib \
  openssl \
  && echo "Getting dependencies for nginx..." \
  && apk add --no-cache --virtual nginx-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  libxslt-dev \
  gd-dev \
  geoip-dev \
  perl-dev \
  libedit-dev \
  mercurial \
  bash \
  alpine-sdk \
  findutils \
  git \
  && echo "Fetching Nginx source..." \
  && wget -O /tmp/nginx-${NGINX_VERSION}.tar.gz ${NGINX_DOWNLOAD_URI} \
  && chdir /tmp \
  && tar zxf nginx-${NGINX_VERSION}.tar.gz \
  && chdir /tmp/nginx-${NGINX_VERSION} \
  && echo "Fetching external modules..." \
  && git clone ${NGINX_TRAFFIC_MODULE} \
  && git clone ${NGINX_UPLOAD_PROGRESS} \
  && echo "Compiling from source" \
  && ./configure ${NGINX_CONFIG} \
  && make \
  && make install \
  && echo "Cleaning up" \
  && apk del nginx-deps \
  && rm -rf /var/cache/apk/* \
  /tmp/*

ADD /rootfs/ /

VOLUME [ "/var/log/nginx",  "/etc/nginx/", "/var/www"]

EXPOSE 80 443
