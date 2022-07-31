###########################################################
# Developer's Guide
###########################################################
#
# All tasks should be explicitly marked as .PHONY at the
# top of the section.
#
# We distinguish two types of tasks: private and public.
#
# "Public" tasks should be created with the description
# using ## comment format:
#
#   public-task: task-dependency ## Task description
#
# Private tasks should start with "_". There should be no
# description E.g.:
#
#   _private-task: task-dependency
#

###########################################################
# Setup
###########################################################

# Include .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

###########################################################
# Project directories
###########################################################

root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

###########################################################
# Config
###########################################################

cache_dir := "$(root_dir)/.cache"
tag := $(shell git describe --tags --abbrev=0 2>/dev/null)
local_image := sitin/mavp2p:local

###########################################################
# Help
###########################################################
.PHONY: help

help: ## Shows help
	@printf "\033[33m%s:\033[0m\n" 'Use: make <command> where <command> one of the following'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[32m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

###########################################################
# Building
###########################################################
.PHONY: build

build: ## Builds project
	@docker build \
    	--build-arg MAVP2P_TAG="$(tag)" \
    	--tag "$(local_image)" \
    	--file Dockerfile .

###########################################################
# Running
###########################################################
.PHONY: up

up: ## Starts all services in Docker
	@docker run --rm --sig-proxy=false -p 14540:14540/udp "$(local_image)" udps:0.0.0.0:14540 udpc:host.docker.internal:14550

###########################################################
# Testing
###########################################################
.PHONY: test

test: ## Run tests
	@echo "Creating builds for all platforms"
	@docker buildx create --use && \
	docker buildx build \
		--build-arg MAVP2P_TAG="$(tag)" \
		--platform linux/arm64/v8,linux/amd64,linux/arm/v6,linux/arm/v7 \
		--tag "$(local_image)" \
		--file Dockerfile .


###########################################################
# Cleaning
###########################################################
.PHONY: clean rmi kill-kill-kill

clean: rmi ## Cleans environment

rmi: ## Removes image
	docker rmi -f "$(local_image)"

kill-kill-kill: ## Stop all Docker containers
	@docker stop $(shell docker ps -q)
