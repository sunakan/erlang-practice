include makefiles/gitignore.mk
include makefiles/help.mk

################################################################################
# 変数
################################################################################
DOCKER_IMAGE   := erlang:23-slim
DOCKER_NETWORK := my-erlang-net

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

.PHONY: network
network:
	@( docker network ls | grep $(DOCKER_NETWORK) ) \
	|| docker network create $(DOCKER_NETWORK)
.PHONY: kosken
kosken: network
	docker run --rm --interactive --tty \
		--network $(DOCKER_NETWORK) \
		--name kosken \
		--workdir /var/local/app2/ \
		--mount type=bind,source=$(PWD)/03-Concurrent-Programming/,target=/var/local/app2/ \
		$(DOCKER_IMAGE) erl -sname ping@kosken -setcookie 'password'
.PHONY: gollum
gollum: network
	@docker run --rm --interactive --tty \
		--network $(DOCKER_NETWORK) \
		--name gollum \
		--workdir /var/local/app2/ \
		--mount type=bind,source=$(PWD)/03-Concurrent-Programming/,target=/var/local/app2/ \
		$(DOCKER_IMAGE) erl -sname pong@gollum -setcookie 'password'
