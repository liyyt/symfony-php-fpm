FROM liyyt/php-fpm:latest
MAINTAINER Aaron Bolanos <aaron@liyyt.com>

RUN composer self-update \
    && mkdir -p /var/www/html/var/cache \
    && mkdir -p /var/www/html/var/logs \
    && mkdir -p /var/www/html/var/sessions \
    && chown -R www-data:www-data /var/www/html/var

VOLUME ["/var/www/html/var/cache", "/var/www/html/var/logs", "/var/www/html/var/sessions"]

EXPOSE 9000
