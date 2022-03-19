# 服务器编译 LLVM，运行之前需要执行 `make bootstrap`

SHELL := /bin/bash
SERVER ?=
SERVER_DIR := ~/llvm

ifeq ($(SERVER),)
$(error "The variable `SERVER` is not been set")
endif

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

bootstrap: install-deps  ## download the source on remote server
	ssh $(SERVER) "git clone git@github.com:topin27/llvm-project.git $(SERVER_DIR)"

sync:  ## sync the source to remote server
	ssh $(SERVER) "mkdir -p $(SERVER_DIR)"
	cd llvm-project; \
		rsync -ra --exclude-from=.gitignore --exclude=.git \
			--exclude=build . $(SERVER):$(SERVER_DIR)/.

install-deps:  ## install build deps on remote server
	ssh $(SERVER) 'apt-get update'
	ssh $(SERVER) 'apt-get install -y cmake libxml2-dev'

build-gen: sync  ## generate build stuff
	ssh $(SERVER) 'cd $(SERVER_DIR); cmake -S llvm -B build -G "Unix Makefiles" \
		-DCMAKE_BUILD_TYPE=Release'

build: sync  ## build source
	ssh $(SERVER) 'cd $(SERVER_DIR); cmake --build build -j8'

sync-back: build  ## sync back the build result
	mkdir -p llvm-project/build/bin/
	rsync -P $(SERVER_DIR)/build/bin/llc llvm-project/build/bin/.

build-clean: sync
	ssh $(SERVER) 'cd $(SERVER_DIR); rm -rf build'
