# 本地编译 llvm

SHELL := /bin/bash
ROOT_DIR := llvm-project/
LLVM_DIR := $(ROOT_DIR)/llvm
BUILD_DIR := $(ROOT_DIR)/build/

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

bootstrap:  ## download the source
	if [ ! -d $(ROOT_DIR) ]; then \
		git clone git@github.com:topin27/llvm-project.git; \
	fi

tags:  ## generate tags
	cd $(LLVM_DIR) && \
		find . \( -name "*.[ch]" -o -name "*.cc" -o -name "*.cpp" \) | \
			ctags -L - && \
		du -sh tags

tags-clean:  ## remove tags
	cd $(LLVM_DIR) && rm -rf tags

CMAKE ?= ~/bins/cmake/bin/cmake
build-gen:  ## generate build stuff
	cd $(ROOT_DIR); $(CMAKE) -S llvm -B build -G "Unix Makefiles" \
		-DCMAKE_BUILD_TYPE=Debug -DLLVM_ENABLE_LIBXML2=off
	# cd $(ROOT_DIR); $(CMAKE) -S llvm/examples -B build -G "Unix Makefiles" \
	# 	-DCMAKE_BUILD_TYPE=Debug -DLLVM_ENABLE_LIBXML2=off

build-llc:  ## only build llc
	cd $(ROOT_DIR); $(CMAKE) --build build -j2 --target llc

build:  ## build the llvm
	cd $(ROOT_DIR); $(CMAKE) --build build -j2

build-clean:  ## clean build stuff
	rm -rf $(BUILD_DIR)

clean: tags-clean build-clean  ## do all clean stuff

.PHONY: test
test:
	cd $(BUILD_DIR); make check-llvm
