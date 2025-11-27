FROM php:8.2-apache

# 1) set working directory
WORKDIR /var/www/html

# 2) instal paket yang dibutuhkan (opsional) dan bersihkan cache apt
RUN apt-get update && apt-get install -y \
    unzip git \
 && rm -rf /var/lib/apt/lists/*

# 3) copy file manifest dahulu untuk memanfaatkan cache layer (jika ada composer)
# COPY composer.json composer.lock ./
# RUN composer install --no-dev --optimize-autoloader

# 4) copy hanya file yang diperlukan (docker build akan honor .dockerignore)
COPY --chown=www-data:www-data . .

# 5) set permission aman
RUN find var -type d -exec chmod 0755 {} \; || true
RUN chown -R www-data:www-data /var/www/html

# 6) gunakan non-root user yang sudah ada (www-data pada image php)
USER www-data

EXPOSE 80

# default command comes from base image (apache2-foreground)
