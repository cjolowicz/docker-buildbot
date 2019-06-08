NAME = buildbot
VERSION = 2.3.1-2
LATEST  = 2.3.1-2
NAMESPACE = $(DOCKER_USERNAME)

ifeq ($(strip $(NAMESPACE)),)
    REPO = $(NAME)
else
    REPO = $(NAMESPACE)/$(NAME)
endif

GIT_TAG = $(shell git describe --exact-match 2>/dev/null || true)
GIT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)

CACHE = $(REPO):$(GIT_BRANCH)

# Tag by full version, its prefixes, and `latest`.
TAGS = $(shell \
    tag="$(VERSION)" ; \
    while : ; do \
        echo "$$tag" ; \
        echo "$$tag" | grep -q [.-] || break ; \
        tag="$${tag%[.-]*}" ; \
    done ; \
    if [ "$(VERSION)" = "$(LATEST)" ] ; then \
        echo "latest" ; \
    fi)

ifeq ($(strip $(TRAVIS_TAG)),)
    IMAGES = $(CACHE)
else
    IMAGES = $(patsubst %, $(REPO):%, $(TAGS))
endif

BUILDFLAGS = $(patsubst %, --tag=%, $(IMAGES))

all: build

build:
	docker build $(BUILDFLAGS) docker

push: login build
	for image in $(IMAGES) ; do \
	    docker push $$image ; \
	done

login:
	@echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USERNAME) --password-stdin

ci: login
	@set -ex; \
	if docker pull $(CACHE) ; then \
	    docker build $(BUILDFLAGS) --cache-from=$(CACHE) docker ; \
	else \
	    docker build $(BUILDFLAGS) docker ; \
	fi ; \
	for image in $(IMAGES) ; do \
	    docker push $$image ; \
	done

.PHONY: all build push login ci
