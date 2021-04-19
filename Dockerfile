FROM alpine:3.13
LABEL maintainer="u0398 <u0398@gmail.com>"

ARG VERSION=3.10

ENV UID=1000 \
    GID=1000

RUN set -xe && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    apk update && \
    apk --no-cache add \
      --virtual .debug-deps \
      bash \
      coreutils \
      grep \
      sed \
      less \
      nano && \
    apk --no-cache add \
      --virtual .run-deps \
      libtorrent \
      rtorrent \
      xmlrpc-c \
      nginx \
      php7 \
      php7-fpm \
      php7-json \
      supervisor && \
    apk add --no-cache \
      --virtual .plug-deps \
      curl \
      ffmpeg \
      mediainfo \
      mktorrent \
      sox \
      unrar \
      unzip \
      zip \
      tar \
      gzip && \
    mkdir /tmp/rutorrent && \
    cd /tmp/rutorrent && \
    curl -sSL https://github.com/Novik/ruTorrent/archive/v${VERSION}.tar.gz | tar xz --strip 1 && \
    cd / && \
    mv /tmp/rutorrent /var/www/rutorrent && \
    rm -rf /var/www/rutorrent/.git* && \
    rm /etc/nginx/conf.d/default.conf

RUN chown -R 1000.1000 /var/www && \
    chown -R 1000.1000 /run && \
    chown -R 1000.1000 /var/lib/nginx && \
    chown -R 1000.1000 /var/log/nginx

COPY root /

VOLUME /data
VOLUME /var/www/rutorrent/share

EXPOSE 80:55000

ENTRYPOINT ["/entrypoint"]

