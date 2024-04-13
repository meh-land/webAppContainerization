FROM php:8.1-apache AS php_apache

# all these updates may not be necessary
RUN apt-get update -y
RUN apt-get install -y unzip libpq-dev libcurl4-gnutls-dev
RUN docker-php-ext-install pdo pdo_mysql bcmath

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

WORKDIR /var/www
# copy from directory w.r.t Dockerfile to container directory specified above
# PROJECT MUST BE IN SAME DIRECTORY AS THIS DOCKERFILE ###VIMP
COPY . . 

COPY --from=composer:2.6.4 /usr/bin/composer /usr/bin/composer 
ENV PORT=8000

ENTRYPOINT [ "entrypoint/entrypoint-webserver.sh" ]
