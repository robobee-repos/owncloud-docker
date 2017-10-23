FROM php:5.6-fpm
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

ARG APT_CACHE
ENV WEB_ROOT /var/www/html

RUN set -x \
  # Optional add proxy entries for apt.
  && if [ -n "${APT_CACHE}" ]; then \
  echo Acquire::ftp::Proxy \"$APT_CACHE\"; >> /etc/apt/apt.conf.d/08proxy;\
  echo Acquire::http::Proxy \"$APT_CACHE\"; >> /etc/apt/apt.conf.d/08proxy;\
  echo Acquire::https::Proxy \"$APT_CACHE\"; >> /etc/apt/apt.conf.d/08proxy;\
  fi

RUN apt-get update && apt-get install -y \
	bzip2 \
	libcurl4-openssl-dev \
	libfreetype6-dev \
	libicu-dev \
	libjpeg-dev \
	libldap2-dev \
	libmcrypt-dev \
	libmemcached-dev \
	libpng12-dev \
	libpq-dev \
	libxml2-dev \
	&& rm -rf /var/lib/apt/lists/*

# https://doc.owncloud.org/server/8.1/admin_manual/installation/source_installation.html#prerequisites
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
	&& docker-php-ext-install exif gd intl ldap mbstring mcrypt mysql opcache pdo_mysql pdo_pgsql pgsql zip

# PECL extensions
RUN set -ex \
	&& pecl install APCu-4.0.10 \
	&& pecl install memcached-2.2.0 \
	&& pecl install redis-2.2.8 \
	&& docker-php-ext-enable apcu memcached redis

ENV OWNCLOUD_VERSION 10.0.2
VOLUME /var/www/html

RUN curl -fsSL -o owncloud.tar.bz2 \
		"https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2" \
	&& curl -fsSL -o owncloud.tar.bz2.asc \
		"https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
# gpg key from https://owncloud.org/owncloud.asc
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys E3036906AD9F30807351FAC32D5D5E97F6978A26 \
	&& gpg --batch --verify owncloud.tar.bz2.asc owncloud.tar.bz2 \
	&& rm -r "$GNUPGHOME" owncloud.tar.bz2.asc \
	&& tar -xjf owncloud.tar.bz2 -C /usr/src/ \
&& rm owncloud.tar.bz2

RUN set -x \
  && docker-php-ext-install ctype \
  && docker-php-ext-install pcntl

# Install Rsync

RUN apt-get update && apt-get install -y \
  rsync \
  && rm -rf /var/lib/apt/lists/*

# Php configuration.

ENV WEB_ROOT /var/www/html
ENV WEB_USER www-data
ENV PHP_MAX_EXECUTION_TIME 300
ENV PHP_MEMORY_LIMIT_MB 128
ENV PHP_FPM_MAX_CHILDREN 10
ENV PHP_FPM_START_SERVERS 2
ENV PHP_FPM_MIN_SPARE_SERVERS 2
ENV PHP_FPM_MAX_SPARE_SERVERS 5
ENV PHP_FPM_MAX_REQUESTS 500
ENV PHP_FPM_REQUEST_SLOWLOG_TIMEOUT 30s
ENV PHP_FPM_CATCH_WORKERS_OUTPUT 1
ENV PHP_OPCACHE_ENABLE_CLI 1
ENV PHP_OPCACHE_ENABLE 1
ENV PHP_OPCACHE_MEMORY_CONSUMPTION_MB 128
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES 6000

RUN set -x \
  && mkdir -p /php-in \
  && mkdir -p /php-fpm-in

ADD rootfs/opcache-recommended.ini /usr/local/etc/php/conf.d/zz-opcache-recommended.ini

ADD rootfs/conf.ini /usr/local/etc/php/conf.d/zz-conf.ini

ADD rootfs/www.conf /usr/local/etc/php-fpm.d/zz-www.conf

# data directory

RUN set -x \
  && mkdir -p /data \
  && chown www-data.www-data /data

VOLUME /data

# Finishing up.

ADD rootfs/docker-entrypoint.sh /docker-entrypoint-in.sh
ADD rootfs/docker-entrypoint-old.sh /entrypoint.sh

RUN set -x \
  && ln -sf /dev/stdout /var/log/php-fpm-slow.log \
  && chmod +x /docker-entrypoint-in.sh \
  && chmod +x /entrypoint.sh \
  && mv /docker-entrypoint-in.sh /docker-entrypoint.sh

USER www-data

WORKDIR $WEB_ROOT

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]
