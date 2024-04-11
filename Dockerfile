FROM php:8.1-apache AS php_apache

RUN apt-get update -y
RUN apt-get install -y unzip libpq-dev libcurl4-gnutls-dev
RUN docker-php-ext-install pdo pdo_mysql bcmath

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

WORKDIR /var/www
COPY . .

COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

ENV PORT=8000
ENTRYPOINT [ "docker/entrypoint.sh" ]

# ==============================================================================
#  node
# FROM node:14-alpine as node

# WORKDIR /var/www
# COPY . .

# RUN npm install --global cross-env
# RUN npm install

# VOLUME /var/www/node_modules

# ==============================================================================
### npm && nodejs

# use ubuntu focal as base image
FROM ubuntu:focal AS nodejs_npm

# set user as root
USER root

# update and upgrade packages
RUN apt update 
RUN apt upgrade -y

# install curl to run set up script
RUN apt install curl -y

# set default shell (login as root && launch an INTERACTIVE SHELL)
SHELL ["/bin/bash", "--login", "-i", "-c"]

# run installation script and source .bashrc
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
RUN source /root/.bashrc

# install node && npm
RUN nvm install 16.15.1
RUN nvm use 16.15.1
RUN npm install -g npm@8.11.0

# return shell to non-interactive mode to stop docker's yelling
SHELL ["/bin/bash", "--login", "-c"]
