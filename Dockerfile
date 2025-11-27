FROM php:8.2-apache

WORKDIR /var/www/html

# Install required packages and enable headers
# enable headers and copy security config
RUN apt-get update \
 && apt-get install -y --no-install-recommends unzip git \
 && a2enmod headers rewrite \
 && rm -rf /var/lib/apt/lists/*

COPY config/security-headers.conf /etc/apache2/conf-available/security-headers.conf
COPY config/security-php.ini /usr/local/etc/php/conf.d/security-php.ini
RUN a2enconf security-headers

# Copy application (honor .dockerignore)
COPY --chown=www-data:www-data . .

# Fix permissions for writable dirs (if any)
RUN if [ -d var ]; then find var -type d -exec chmod 0755 {} \; || true; fi \
 && chown -R www-data:www-data /var/www/html

USER www-data
EXPOSE 80
