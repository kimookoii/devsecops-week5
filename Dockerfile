# ---- Base image ----
FROM php:8.2-apache

# ---- Set working dir ----
WORKDIR /var/www/html

# ---- Install only if you need extra system packages (optional) ----
# Hapus lines ini jika tidak perlu paket tambahan.
RUN apt-get update \
 && apt-get install -y --no-install-recommends unzip git \
 && rm -rf /var/lib/apt/lists/*

# ---- If you use Composer, copy manifest first to leverage cache ----
# Uncomment and adjust if composer used:
# COPY composer.json composer.lock ./
# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
#  && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
#  && composer install --no-dev --no-interaction --optimize-autoloader \
#  && rm composer-setup.php

# ---- Copy application files, set ownership to www-data (non-root) ----
# .dockerignore MUST exist and exclude sensitive files
COPY --chown=www-data:www-data . .

# ---- Fix permissions for writable dirs (adjust if your app uses different dir) ----
# Only change what is necessary (avoid chmod -R 777)
RUN if [ -d var ]; then find var -type d -exec chmod 0755 {} \; || true; fi \
 && chown -R www-data:www-data /var/www/html

# ---- Run as non-root user (apache in php images uses www-data) ----
USER www-data

# ---- Expose port and default command inherited from base image ----
EXPOSE 80

# NOTE: base image 'php:8.2-apache' already provides the cmd to start apache.
