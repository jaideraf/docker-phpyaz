# This is the Dockerfile for jaideraf/phpyaz
FROM ubuntu:22.04

FROM php:8.2-apache

# set timezone
ENV TZ=America/Sao_Paulo
RUN set -eux; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /opt

# add repository, update packages and install dependencies
RUN apt-get update && apt-get install -y \
    gnupg2 \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget "http://archive.ubuntu.com/ubuntu/pool/main/i/icu/libicu66_66.1-2ubuntu2.1_amd64.deb"
RUN dpkg -i libicu66_66.1-2ubuntu2.1_amd64.deb ; rm libicu66_66.1-2ubuntu2.1_amd64.deb

RUN echo "deb [signed-by=/usr/share/keyrings/indexdata.gpg] https://ftp.indexdata.com/ubuntu focal main" \
    | tee -a /etc/apt/sources.list \
    && wget -qO - https://ftp.indexdata.com/debian/indexdata.asc \
    | gpg --dearmor | tee /usr/share/keyrings/indexdata.gpg >/dev/null

RUN apt-get update && apt-get install -y --no-install-recommends \
    libyaz5 \
    libyaz5-dev \
    yaz \
    yaz-icu \
    && rm -rf /var/lib/apt/lists/*

# install phpyaz extension
RUN pecl install yaz
RUN docker-php-ext-enable yaz

# install intl extension
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

WORKDIR /var/www/html