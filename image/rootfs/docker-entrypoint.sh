#!/bin/bash
set -xe

function check_files_exists() {
  ls "$1" 1> /dev/null 2>&1
}

function copy_file() {
  file="$1"; shift
  dir="$1"; shift
  mod="$1"; shift
  if [ -e "$file" ]; then
    mkdir -p "$dir"
    cp "$file" "$dir/$file"
    chmod $mod "$dir/$file"
  fi
}

function copy_php_conf() {
  dir="/php-in"
  if [ ! -d "${dir}" ]; then
    return
  fi
  cd "${dir}"
  if ! check_files_exists "*.ini"; then
    return
  fi
  rsync -v "${dir}/*.ini" /usr/local/etc/php/conf.d/
 }
 
function copy_php_fpm_conf() {
  dir="/php-fpm-in"
  if [ ! -d "${dir}" ]; then
    return
  fi
  cd "${dir}"
  if ! check_files_exists "*.conf"; then
    return
  fi
  rsync -v "${dir}/*.conf" /usr/local/etc/php-fpm.d/
 }
 
function copy_owncloud() {
  dir="/owncloud-in"
  if [ ! -d ${dir} ]; then
    return
  fi
  cd "${dir}"
  copy_file config.php "$WEB_ROOT/config/" 0644
}

function sync_owncloud() {
  cd "${WEB_ROOT}"
  if [ ! -e 'version.php' ]; then
    return
  fi
  rsync -rlD -u /usr/src/owncloud/. .
}

CRON=1

if [[ "$3" == "cron.php" ]]; then
  CRON
fi

copy_php_conf
copy_php_fpm_conf
copy_owncloud
sync_owncloud

echo "Running as `id`"
cd "$WEB_ROOT"
exec bash -x -- /entrypoint.sh "$@"
