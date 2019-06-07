NAME = buildbot
VERSION = 2.2.0-1
NAMESPACE = $(DOCKER_USERNAME)

ifeq ($(strip $(NAMESPACE)),)
    REPO = $(NAME)
else
    REPO = $(NAMESPACE)/$(NAME)
endif

# Tag by full version, its prefixes, and `latest`.
TAGS = $(shell \
    tag="$(VERSION)" ; \
    while : ; do \
        echo "$$tag" ; \
        echo "$$tag" | grep -q [.-] || break ; \
        tag="$${tag%[.-]*}" ; \
    done ; \
    echo "latest")

IMAGES = $(patsubst %, $(REPO):%, $(TAGS))
IMAGE = $(firstword $(IMAGES))
BUILDFLAGS = $(patsubst %, --tag=%, $(IMAGES))

all: build

build:
	@if docker image ls --format='{{.Repository}}:{{.Tag}}' | \
	        grep -q '^$(IMAGE)$$' ; then \
	    ( set -x ; docker build $(BUILDFLAGS) --cache-from=$(IMAGE) $(NAME) ) ; \
	else \
	    ( set -x ; docker build $(BUILDFLAGS) $(NAME) ) ; \
	fi

push: login build
	@for image in $(IMAGES) ; do \
	    ( set -x ; docker push $$image ) ; \
	done

pull:
	@for image in $(IMAGES) ; do \
	    ( set -x ; docker pull $$image ) ; \
	done

login:
	@echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USERNAME) --password-stdin

.PHONY: all build push pull login
