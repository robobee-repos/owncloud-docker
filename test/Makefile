include ../utils/Makefile.help
include ../utils/Makefile.functions

export NAME := owncloud
export ROOT_DIR := $(shell realpath ./root)
export NGINX_CONF_DIR := $(shell realpath ./nginx-in)

test: setup ##@targets Starts docker compose.
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
	mkdir -p $(ROOT_DIR)/html
	mkdir -p $(ROOT_DIR)/data
	mkdir -p $(ROOT_DIR)/bitnami/mariadb
	sudo chmod o+rwX $(ROOT_DIR)/html
	sudo chmod o+rwX $(ROOT_DIR)/data
	sudo chmod o+rwX $(ROOT_DIR)/bitnami/mariadb
.PHONY: setup
