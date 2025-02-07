FROM node:14 AS BUILDER

RUN mkdir /tmp/panel

WORKDIR /tmp/panel

RUN \
 apt update \
 && apt install git \
 && git clone -b gameinfo https://github.com/Shigbeard/pterodactyl-panel --depth 1 \
 && cd pterodactyl-panel \
 && yarn install \
 && yarn build:production 

FROM alpine:3.15

LABEL maintainer="MrFlutters"

ARG VERSION

ENV STARTUP_TIMEOUT=5 \
    PANEL_VERSION=${VERSION}

WORKDIR /var/www/html/

RUN \
 apk --update add curl gettext nginx php7 php7 php7-bcmath php7-common php7-dom php7-fileinfo \
 php7-fpm php7-gd php7-memcached php7-mbstring php7-openssl php7-pdo php7-phar php7-json php7-sodium \
 php7-pdo_mysql php7-session php7-simplexml php7-tokenizer php7-ctype php7-zlib php7-zip tini \
 && mkdir -p /var/www/html /run/nginx /etc/nginx/conf.d/
 
COPY --from=BUILDER /tmp/panel/pterodactyl-panel /var/www/html

RUN \
 chmod -R 755 storage/* bootstrap/cache \
 && find storage -type d > .storage.tmpl \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && cp .env.example .env \
 && composer install --ansi --no-dev --optimize-autoloader \
 && rm .env ./storage -rf \
 && chown nginx:nginx * -R

COPY ./ /

# Remove Migration that isn't compatible
RUN rm /var/www/html/database/migrations/2020_10_10_165437_change_unique_database_name_to_account_for_server.php

RUN \
    ln -s /data/storage storage; \
    ln -s /data/pterodactyl.conf .env;

VOLUME [ "/data" ]

# Expose HTTP and HTTPS ports
EXPOSE 80 443

ENTRYPOINT [ "/sbin/tini", "--", "/entrypoint.sh" ]

CMD [ "p:start" ]
