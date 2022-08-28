FROM ubuntu:latest

ARG omeka_version=2.7.1

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt install -y software-properties-common
RUN apt-add-repository -y ppa:ondrej/php
RUN apt-get update

RUN apt -y install \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    git-core \
    apt-utils \
    unzip \
    libfreetype6-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    libexif-dev \
    zlib1g-dev \
    imagemagick \
    apache2 \
    php7.4 \
    libapache2-mod-php7.4 \
    php7.4-common \
    php7.4-mysql \
    php7.4-xml

RUN rm -rf /var/www/html/*
ADD https://github.com/omeka/Omeka/releases/download/v${omeka_version}/omeka-${omeka_version}.zip /tmp/omeka-classic.zip
RUN unzip -d /tmp/ /tmp/omeka-classic.zip && mv /tmp/omeka-${omeka_version}/* /var/www/html/ && rm -rf /tmp/omeka-classic*

RUN a2enmod rewrite
COPY files/php.ini /etc/php/7.4/apache2/

COPY /files/.htaccess /var/www/html/.htaccess
COPY ./files/db.ini /var/www/html/db.ini
COPY ./files/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R +w /var/www/html/files

EXPOSE 80
CMD apachectl -D FOREGROUND
