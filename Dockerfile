FROM alpine:3.13
LABEL maintainer="u0398 <u0398@gmail.com>"

ARG VERSION=3.10

ENV PUID \
    PGID

RUN set -xe && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    apk update && \
    apk add --no-cache \
        --virtual .run-deps \
#        apache2-utils \
#        ca-certificates \
#        libtorrent \
        su-exec
        nginx \
        php7 \
        php7-fpm \
        php7-json \
#        rtorrent \
#        xmlrpc-c \
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
    apk add --no-cache tar && \
    mkdir /tmp/rutorrent && cd /tmp/rutorrent && \
    curl -sSL https://github.com/Novik/ruTorrent/archive/v${VERSION}.tar.gz | tar xz --strip 1 && \
    cd / && mv /tmp/rutorrent /var/www/rutorrent && \
    apk del tar && \
    rm -rf /var/www/rutorrent/.git*

COPY root /

VOLUME /socket
VOLUME /var/www/rutorrent/share

EXPOSE 8890 80

ENTRYPOINT ["/entrypoint"]

CMD ["supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]
