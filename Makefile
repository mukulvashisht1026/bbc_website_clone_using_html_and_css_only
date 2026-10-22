COMPOSE := docker compose -f compose.yaml
PORT ?= 8084
DOCKER_PLATFORM ?= linux/amd64
IMAGE_PREFIX ?= mukul-local
IMAGE_TAG ?= latest
export PORT DOCKER_PLATFORM IMAGE_PREFIX IMAGE_TAG
IMAGE_ARCHIVE ?= images.tar

.PHONY: help build deploy up stop logs status export load
.DEFAULT_GOAL := help

help:
	@echo "make deploy  Build and start this project; wait for health checks"
	@echo "make build   Build images only"
	@echo "make up      Start already-built images"
	@echo "make stop    Stop and remove this project's containers"
	@echo "make logs    Follow container logs"
	@echo "make status  Show container status"
	@echo "make export  Save images to IMAGE_ARCHIVE (default images.tar)"
	@echo "make load    Load images from IMAGE_ARCHIVE"

build:
	$(COMPOSE) build

deploy:
	$(COMPOSE) up -d --build --wait

up:
	$(COMPOSE) up -d --no-build --wait

stop:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

status:
	$(COMPOSE) ps

export:
	docker image save -o "$(IMAGE_ARCHIVE)" $$($(COMPOSE) config --images)

load:
	docker image load -i "$(IMAGE_ARCHIVE)"
