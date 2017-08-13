# OwnCloud-Docker

## Description

It modifies the parent image insofar as
it can take input configuration files to override the image configuration
files, allowing for Kubernetes config maps. Additionally, it includes
the rsync daemon and configures a separate data directory. The rsync
daemon can be used to backup the ownCloud installation and the data directory.

## Environment Parameters

| Variable | Default | Description |
| ------------- | ------------- | ----- |
| PHP_MAX_EXECUTION_TIME  | 300 | max_execution_time |
| PHP_MEMORY_LIMIT_MB | 128 | memory_limit |
| PHP_FPM_MAX_CHILDREN | 10 | pm.max_children |
| PHP_FPM_START_SERVERS | 2 | pm.start_servers |
| PHP_FPM_MIN_SPARE_SERVERS | 2 | pm.min_spare_servers |
| PHP_FPM_MAX_SPARE_SERVERS | 5 | pm.max_spare_servers |
| PHP_FPM_MAX_REQUESTS | 500 | pm.max_requests |
| PHP_FPM_REQUEST_SLOWLOG_TIMEOUT | 30s | request_slowlog_timeout |
| PHP_FPM_CATCH_WORKERS_OUTPUT | 1 | catch_workers_output |
| PHP_OPCACHE_ENABLE_CLI | 1 | opcache.enable_cli |
| PHP_OPCACHE_ENABLE | 1 | opcache.enable |
| PHP_OPCACHE_MEMORY_CONSUMPTION_MB | 128 | opcache.memory_consumption |

## Exposed Ports

| Port | Description |
| ------------- | ----- |
| 9000  | php-fpm |

## Directories

| Path | Description |
| ------------- | ----- |
| /var/www/html  | www-root directory. |
| /data | Reserved ownCloud user data directory. |

## Input Configration

| Source | Destination |
| ------------- | ------------- |
| /php-in/*.ini | /usr/local/etc/php/ |
| /php-fpm-in/*.conf | /usr/local/etc/php-fpm.d/ |

## Test

The docker-compose file `test.yaml` can be used to startup MySQL and the
Wordpress base containers. The Wordpress installation can be then accessed
from `localhost:8080`.

```
docker-compose -f test.yaml up
```

## Optimize php-fpm

 ```
find /var/www/html -iname *.php|wc -l
 ```
