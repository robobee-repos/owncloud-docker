FROM owncloud:9.1.6-fpm
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

RUN set -x \
  && apt-get update \
  && apt-get install -y \
    rsync \
	&& rm -rf /var/lib/apt/lists/*

# Php configuration.

ENV PHP_MAX_EXECUTION_TIME 300
ENV PHP_MEMORY_LIMIT_MB 128
ENV PHP_FPM_MAX_CHILDREN 5
ENV PHP_FPM_START_SERVERS 2
ENV PHP_FPM_MIN_SPARE_SERVERS 1
ENV PHP_FPM_MAX_SPARE_SERVERS 3
ENV PHP_OPCACHE_ENABLE_CLI 1
ENV PHP_OPCACHE_ENABLE 1
ENV PHP_OPCACHE_MEMORY_CONSUMPTION_MB 128

RUN set -x \
  && mkdir -p /php-in \
  && mkdir -p /php-fpm-in

RUN { \
    echo '[www]'; \
    echo 'pm = dynamic'; \
    echo 'pm.max_children = ${PHP_FPM_MAX_CHILDREN}'; \
    echo 'pm.start_servers = ${PHP_FPM_START_SERVERS}'; \
    echo 'pm.min_spare_servers = ${PHP_FPM_MIN_SPARE_SERVERS}'; \
    echo 'pm.max_spare_servers = ${PHP_FPM_MAX_SPARE_SERVERS}'; \
    echo 'pm.status_path = /phpstatus'; \
    echo 'ping.path = /ping'; \
    echo 'ping.response = pong'; \
} > /usr/local/etc/php-fpm.d/99-www.conf

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=${PHP_OPCACHE_MEMORY_CONSUMPTION_MB}'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=${PHP_OPCACHE_ENABLE_CLI}'; \
    echo 'opcache.enable=${PHP_OPCACHE_ENABLE}'; \
    echo 'opcache.revalidate_freq=60'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
    echo 'max_execution_time=${PHP_MAX_EXECUTION_TIME}'; \
    echo 'memory_limit=${PHP_MEMORY_LIMIT_MB}M'; \
    echo 'realpath_cache_size = 1MB'; \
} > /usr/local/etc/php/conf.d/99-conf.ini

# Finishing up.

ADD rootfs/docker-entrypoint.sh /docker-entrypoint-in.sh

RUN set -x \
  && chmod +x /docker-entrypoint-in.sh \
  && mv /docker-entrypoint-in.sh /docker-entrypoint.sh

USER www-data

WORKDIR $WEB_ROOT

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]
