include makefiles/gitignore.mk
include makefiles/help.mk

################################################################################
# 変数
################################################################################
DOCKER_IMAGE   := erlang:23-slim
DOCKER_NETWORK := my-erlang-net

################################################################################
# マクロ
################################################################################
# $(1): erlする時のsname
# $(2): コンテナ名(erlangノード間が通信する時に使うホスト名でもある)
define docker-run
  docker run \
    --rm \
    --interactive \
    --tty \
    --network $(DOCKER_NETWORK) \
    --name $(2) \
    --workdir /var/local/app2/ \
    --mount type=bind,source=$(PWD)/03-Concurrent-Programming/,target=/var/local/app2/ \
    $(DOCKER_IMAGE) erl -sname $(1)@$(2) -setcookie 'password'
endef

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

# ping/pong用
.PHONY: kosken
kosken: network
	$(call docker-run,ping,kosken)
.PHONY: gollum
gollum: network
	$(call docker-run,pong,gollum)

# 3.5 A Larger Example用
.PHONY: server
server: network
	$(call docker-run,messenger,super)
.PHONY: c1
c1: network
	$(call docker-run,c1,bilbo)
.PHONY: c2
c2: network
	$(call docker-run,c2,kosken)
.PHONY: c3
c3: network
	$(call docker-run,c3,gollum)

clean:
	docker container prune
