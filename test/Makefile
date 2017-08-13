include ../utils/Makefile.help
include ../utils/Makefile.functions

NAME := owncloud
ROOT_DIR:=$(shell realpath root)
NGINX_CONF_DIR:=$(shell realpath nginx-in)

test: setup ##@targets Starts docker compose.
	export ROOT_DIR="$(ROOT_DIR)" \
	&& export NGINX_CONF_DIR="$(NGINX_CONF_DIR)" \
	&& docker-compose -p ${NAME} -f test.yaml up
.PHONY: test

clean: rm ##@targets Removes docker containers and created files.
	if [ -d $(ROOT_DIR) ]; then \
	sudo rm -rf $(ROOT_DIR); \
	fi

rm: ##@targets Removes docker containers.
	export ROOT_DIR="$(ROOT_DIR)" \
	&& export NGINX_CONF_DIR="$(NGINX_CONF_DIR)" \
	&& docker-compose -p ${NAME} -f test.yaml stop \
	&& docker-compose -p ${NAME} -f test.yaml rm

setup:
	if ! [ -d $(ROOT_DIR)/html ]; then \
	mkdir -p $(ROOT_DIR)/html; \
	fi
	if ! [ -d $(ROOT_DIR)/data ]; then \
	mkdir -p $(ROOT_DIR)/data; \
	fi
	if ! [ -d $(ROOT_DIR)/bitnami/mariadb ]; then \
	mkdir -p $(ROOT_DIR)/bitnami/mariadb; \
	fi
	sudo chown 33:33 -R $(ROOT_DIR)/html
	sudo chown 33:33 -R $(ROOT_DIR)/data
	sudo chown 1001:1001 -R $(ROOT_DIR)/bitnami/mariadb
.PHONY: setup
