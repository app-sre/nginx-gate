.PHONY: build push

IMAGE_NAME := quay.io/app-sre/nginx-gate
IMAGE_TAG := $(shell git rev-parse --short=7 HEAD)

ifneq (,$(wildcard $(CURDIR)/.docker))
    DOCKER_CONF := $(CURDIR)/.docker
else
    DOCKER_CONF := $(HOME)/.docker
endif

build:
	@docker build -t $(IMAGE_NAME):latest .
	@docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(IMAGE_TAG)

# For local testing purposes
compose:
	@docker compose up --build

push:
	@docker --config=$(DOCKER_CONF) push $(IMAGE_NAME):latest
	@docker --config=$(DOCKER_CONF) push $(IMAGE_NAME):$(IMAGE_TAG)
