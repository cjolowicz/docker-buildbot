export TOPDIR = $(shell pwd)

DIRS = buildbot buildbot-worker-example

all: build

build:
	set -ex; for dir in $(DIRS) ; do \
	    $(MAKE) -f $(TOPDIR)/Makefile.sub -C $$dir build ; \
	done

push: login
	set -ex; for dir in $(DIRS) ; do \
	    $(MAKE) -f $(TOPDIR)/Makefile.sub -C $$dir push ; \
	done

pull:
	set -x; for dir in $(DIRS) ; do \
	    $(MAKE) -f $(TOPDIR)/Makefile.sub -C $$dir pull ; \
	done

login:
	@echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USERNAME) --password-stdin

.PHONY: all build push pull login
