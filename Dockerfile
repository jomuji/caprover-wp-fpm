# WordPress 7.1.4 on PHP 8.4.
# PHP 8.2 loses security support 2026-12-31; WordPress recommends 8.4+ for new installs.
# Pinned rather than floating so a redeploy cannot silently change the runtime.
FROM wordpress:7.1.4-php8.4-fpm

RUN apt-get update && apt-get install -y --no-install-recommends nginx ca-certificates curl \
  && rm -rf /var/lib/apt/lists/* \
  && rm -f /etc/nginx/sites-enabled/default

# PHP limits must be >= nginx client_max_body_size, otherwise uploads fail
# inside PHP while nginx happily accepts them.
COPY php.ini /usr/local/etc/php/conf.d/zz-custom.ini

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /var/www/html
EXPOSE 80
CMD ["/start.sh"]
