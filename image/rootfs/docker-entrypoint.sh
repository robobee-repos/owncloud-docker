#!/bin/bash
set -e

function sync_owncloud() {
  cd "${WEB_ROOT}"
  rsync -rlD -u /usr/src/owncloud/. .
}

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
  sync_owncloud
fi

cd "${WEB_ROOT}"
exec "$@"
