#!/usr/bin/env bash
set -e

# If volume is empty, copy WP core into it (but keep any existing wp-content)
if [ ! -f /var/www/html/wp-settings.php ]; then
  echo "Populating /var/www/html with WordPress core..."
  tar cf - -C /usr/src/wordpress --exclude=wp-content . | tar xf - -C /var/www/html
  chown -R www-data:www-data /var/www/html
fi

# Run the official wordpress entrypoint to generate wp-config.php etc, then start php-fpm
docker-entrypoint.sh php-fpm -D

# Start nginx in foreground
nginx -g "daemon off;"
