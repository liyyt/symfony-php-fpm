FROM php:fpm-alpine
MAINTAINER Aaron Bolanos <aaron@liyyt.com>

# persistent / runtime deps
ENV BUILD_DEPS \
    autoconf \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkgconf \
    re2c

ENV PERSISTENT_DEPS \
    libmcrypt-dev

ENV PHP_EXT \
    iconv \
    mbstring \
    mcrypt \
    opcache \
    pdo \
    pdo_mysql

RUN set -xe \
    && apk upgrade --update \
	&& apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS \
    && docker-php-ext-install $PHP_EXT \
    && pecl install redis apcu intl \
    && docker-php-ext-enable --ini-name 10-apcu.ini apcu \
    && docker-php-ext-enable --ini-name 10-redis.ini redis \
    && apk del .build-deps \
    && curl -SLO "https://getcomposer.org/installer" \
    && curl -fsSL "https://getcomposer.org/installer" -o /tmp/installer \
    && php /tmp/installer \
    && mv /var/www/html/composer.phar /usr/local/bin/composer \
    && rm /tmp/installer \
    && mkdir -p /var/www/html/var/cache \
    && mkdir -p /var/www/html/var/logs \
    && mkdir -p /var/www/html/var/sessions \
    && chown -R www-data:www-data /var/www/html/var

COPY config/php/php.development.ini /usr/local/etc/php/php.ini
COPY config/php-fpm.d/docker.conf /usr/local/etc/php-fpm.d/docker.conf
COPY config/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY config/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

VOLUME ["/var/www/html/var/cache", "/var/www/html/var/logs", "/var/www/html/var/sessions"]

EXPOSE 9000
