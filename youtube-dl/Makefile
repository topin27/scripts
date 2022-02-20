SHELL := /bin/bash

YTBDL_SRC := ~/Workspace/src/youtube-dl/
LIST_FILE ?= videos.list
CMD_ARGS ?= --proxy socks://127.0.0.1:1080
YTBDL_CMD := python -m youtube_dl $(CMD_ARGS)

help:  ## this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

download:  ## download videos list in videos.list
	for i in `cat $(LIST_FILE)`; do \
		cd $(YTBDL_SRC); $(YTBDL_CMD) $$i; \
	done
