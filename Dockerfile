FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies dan keyring sury
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        ca-certificates \
        vim \
        nano \
        lsb-release \
        zip unzip 7zip \
        logrotate \
        apt-transport-https && \
    curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
    dpkg -i /tmp/debsuryorg-archive-keyring.deb && \
    rm -f /tmp/debsuryorg-archive-keyring.deb && \
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/nginx/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/nginx.list' && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    php8.4-cli \
    php8.4-fpm \
    php8.4-mysql \
    php8.4-redis \
    php8.4-zip \
    php8.4-curl \
    php8.4-mbstring \
    php8.4-xml \
    php8.4-intl \
    php8.4-bcmath \
    php8.4-soap \
    php8.4-gd \
    php8.4-opcache \
    php8.4-readline \
    nginx \
    supervisor && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/log/php
RUN chown -R www-data:www-data /var/log/php

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php

RUN chown -R www-data:www-data /var/www

WORKDIR /var/www/html

# Copy project files
COPY --chown=www-data:www-data . .

USER www-data

RUN composer install --optimize-autoloader --no-interaction --prefer-dist \
 && composer clear-cache \
 && npm install \
 && npm run build:ssr \
 && npm cache clean --force

RUN rm -rf /var/www/.npm

RUN php artisan optimize && \
    php artisan storage:link

USER root

# Copy nginx config
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/sites-available/default /etc/nginx/sites-available/default

COPY ./docker/php/8.4/fpm/pool.d/www.conf /etc/php/8.4/fpm/pool.d/www.conf
COPY ./docker/php/8.4/fpm/php.ini /etc/php/8.4/fpm/php.ini
COPY ./docker/php/8.4/fpm/php-fpm.conf /etc/php/8.4/fpm/php-fpm.conf

# Copy supervisor configs (per program)
COPY ./docker/supervisor/ /etc/supervisor/conf.d/

COPY docker/logrotate/supervisor-logs /etc/logrotate.d/supervisor-logs

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]

HEALTHCHECK CMD curl --fail http://127.0.0.1/up || exit 1
