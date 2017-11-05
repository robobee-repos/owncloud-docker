#!/bin/bash
set -e

source /docker-entrypoint-utils.sh
set_debug
echo "Running as `id`"

CRON=0

if [[ "$3" == "cron.php" ]]; then
  CRON=1
fi

if [[ $CRON == 0 ]]; then
  copy_files "/php-in" "/usr/local/etc/php/conf.d" "*.ini"
  copy_files "/php-fpm-in" "/usr/local/etc/php-fpm.d" "*.conf"
  copy_files "/owncloud-in" "${WEB_ROOT}/config" "config.php"
  sync_dir /usr/src/owncloud ${WEB_ROOT}
fi

cd "${WEB_ROOT}"
exec "$@"
