# Base image
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install minimal system packages if needed (optional)
RUN apt-get update \
 && apt-get install -y --no-install-recommends unzip git \
 && rm -rf /var/lib/apt/lists/*

# If you use Composer, uncomment the COPY + composer install block below
# COPY composer.json composer.lock ./
# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
#  && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
#  && composer install --no-dev --no-interaction --optimize-autoloader \
#  && rm composer-setup.php

# Copy application files and set ownership to non-root web user
# .dockerignore must exclude secrets, .git, vendor, etc.
COPY --chown=www-data:www-data . .

# Fix permissions for specific writable directories if they exist
RUN if [ -d var ]; then find var -type d -exec chmod 0755 {} \; || true; fi \
 && chown -R www-data:www-data /var/www/html

# Run as non-root user
USER www-data

# Expose port
EXPOSE 80
