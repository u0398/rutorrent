FROM alpine:3.13
LABEL maintainer="u0398 <u0398@gmail.com>"

ARG VERSION=3.10

ENV PUID \
    PGID

RUN set -xe && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    apk --no-cache add \
      --virtual .run-deps \
      php8 \
      php8-fpm \
      php8-opcache \
      php8-mysqli \
      php8-json \
      php8-openssl \
      php8-curl \
      php8-zlib \
      php8-xml \
      php8-phar \
      php8-intl \
      php8-dom \
      php8-xmlreader \
      php8-ctype \
      php8-session \
      php8-mbstring \
      php8-gd \
      nginx \
      xmlrpc-c \
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
      zip && \
    apk --no-cache add \
      tar && \
    mkdir /tmp/rutorrent && \
    cd /tmp/rutorrent && \
    curl -sSL https://github.com/Novik/ruTorrent/archive/v${VERSION}.tar.gz | tar xz --strip 1 && \
    cd / && \
    mv /tmp/rutorrent /var/www/rutorrent && \
    apk del tar && \
    rm -rf /var/www/rutorrent/.git* && \
    rm /etc/nginx/conf.d/default.conf

RUN chown -R 1000.1000 /var/www/rutorrent && \
    chown -R 1000.1000 /run && \
    chown -R 1000.1000 /var/lib/nginx && \
    chown -R 1000.1000 /var/log/nginx

COPY root /

USER 1000

VOLUME /socket
VOLUME /var/www/rutorrent/share

EXPOSE 8890:80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

#ENTRYPOINT ["/entrypoint"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8890/fpm-ping

