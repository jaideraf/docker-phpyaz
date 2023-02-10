# This is the Dockerfile for jaideraf/phpyaz
FROM ubuntu:focal

FROM php:7.4-apache

# set timezone
ENV TZ=America/Sao_Paulo
RUN set -eux; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# update packages and install dependencies 
RUN apt-get update && apt-get install -y --no-install-recommends \
    automake \
    bison \
    docbook \
    docbook-xml \
    docbook-xsl \
    git \
    libexpat1-dev \
    libicu-dev \
    libtool \
    libwrap0-dev \
    libxslt1-dev \
    tcl \
    xsltproc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# build Yaz
RUN git clone https://github.com/indexdata/yaz.git; \
    cd yaz && git checkout v5.31.1; \
    ./buildconf.sh; \
    ./configure --with-iconv --with-icu; \
    make; \
    make install

# install phpyaz extension
RUN pecl install yaz
RUN docker-php-ext-enable yaz
