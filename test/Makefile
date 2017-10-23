include ../utils/Makefile.help
include ../utils/Makefile.functions

export NAME := owncloud
export ROOT_DIR := $(shell realpath ./root)
export NGINX_CONF_DIR := $(shell realpath ./nginx-in)

test: setup ##@targets Starts docker compose.
	echo $$NAME
	docker-compose -p ${NAME} -f test.yaml up
.PHONY: test

clean: rm ##@targets Removes docker containers and created files.
	if [ -d $(ROOT_DIR) ]; then \
	sudo rm -rf $(ROOT_DIR); \
	fi
.PHONY: clean

rm: ##@targets Removes docker containers.
	docker-compose -p ${NAME} -f test.yaml stop
	docker-compose -p ${NAME} -f test.yaml rm -f
.PHONY: rm

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
	sudo chmod o+rwX $(ROOT_DIR)/html
	sudo chmod o+rwX $(ROOT_DIR)/data
	sudo chmod o+rwX $(ROOT_DIR)/bitnami/mariadb
.PHONY: setup
