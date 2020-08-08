include makefiles/gitignore.mk
include makefiles/help.mk

################################################################################
# 変数
################################################################################
DOCKER_IMAGE := erlang:23-slim

################################################################################
# タスク
################################################################################
.PHONY: erl
erl:
	docker run \
		--rm \
		--interactive \
		--tty \
		--workdir /var/local/app2/ \
		--mount type=bind,source=$(PWD)/02-Sequential-Programming/,target=/var/local/app/ \
		--mount type=bind,source=$(PWD)/03-Concurrent-Programming/,target=/var/local/app2/ \
		$(DOCKER_IMAGE) erl
