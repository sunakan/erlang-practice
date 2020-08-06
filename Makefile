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
		--workdir /var/local/app/ \
		--mount type=bind,source=$(PWD),target=/var/local/app/ \
		$(DOCKER_IMAGE) erl
