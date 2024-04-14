# this image is based on debian 12 bookworm
FROM php:8.1-apache AS php_apache

# set user as root
USER root

# update and upgrade packages
RUN apt-get update
RUN apt-get upgrade -y

# install some essentials
RUN apt-get install -y build-essential libxml2-dev \
    libsqlite3-dev curl libcurl4-openssl-dev pkg-config \
    libssl-dev libonig-dev libzip-dev zlib1g-dev libpng-dev \
    libjpeg-dev libfreetype6-dev libgmp-dev libpq-dev libicu-dev \
    libbz2-dev libxpm-dev libwebp-dev libtidy-dev libxslt1-dev zip \
    unzip wget git vim 
RUN docker-php-ext-install zip

# set default shell (login as root && launch an INTERACTIVE SHELL)
SHELL ["/bin/bash", "--login", "-i", "-c"]

# install composer
WORKDIR /
RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# change working directory && copy backend files to container
WORKDIR /var/www
COPY ./GP_laravel .
COPY entrypoint-webserver.sh .

# install composer stuff
RUN composer install --no-progress --no-interaction

# install laravel
RUN composer global require laravel/installer

# return shell to non-interactive mode to stop docker's yelling
SHELL ["/bin/bash", "--login", "-c"]

# entrypoint script to launch webserver
#ENV PORT=8000
ENTRYPOINT [ "/bin/bash", "entrypoint-webserver.sh"]