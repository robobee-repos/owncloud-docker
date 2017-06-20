REPOSITORY := erwin82
NAME := owncloud
VERSION ?= 10.0.2-fpm-r1

build: _build ##@targets Builds the docker image.

clean: _clean ##@targets Removes the local docker image.

deploy: _deploy ##@targets Deploys the docker image to the repository.

include ../utils/Makefile.help
include ../utils/Makefile.functions
include ../utils/Makefile.image

.PHONY +: build clean deploy
