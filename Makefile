NAME = buildbot
VERSION = 2.3.1-1
LATEST  = 2.3.1-1
NAMESPACE = $(DOCKER_USERNAME)

ifeq ($(strip $(NAMESPACE)),)
    REPO = $(NAME)
else
    REPO = $(NAMESPACE)/$(NAME)
endif

CACHE = $(REPO):$(VERSION)

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

IMAGES = $(patsubst %, $(REPO):%, $(TAGS))
BUILDFLAGS = $(patsubst %, --tag=%, $(IMAGES))

all: build

build:
	docker build $(BUILDFLAGS) $(NAME)

push: login build
	for image in $(IMAGES) ; do \
	    docker push $$image ; \
	done

login:
	@echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USERNAME) --password-stdin

ci: login
	@set -ex; \
	if docker pull $(CACHE) ; then \
	    docker build $(BUILDFLAGS) --cache-from=$(CACHE) $(NAME) ; \
	else \
	    docker build $(BUILDFLAGS) $(NAME) ; \
	fi ; \
	if [ -n "$(TRAVIS_TAG)" ] ; then \
	    for image in $(IMAGES) ; do \
	        docker push $$image ; \
	    done ; \
	fi

.PHONY: all build push login ci
