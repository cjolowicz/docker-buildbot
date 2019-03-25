REPO = $(DOCKER_USERNAME)

ifeq ($(strip $(REPO)),)
    IMAGE = buildbot-master:1.8.0
else
    IMAGE = $(REPO)/buildbot-master:1.8.0
endif

all: build

build: Dockerfile
	if docker image ls --format='{{.Repository}}:{{.Tag}}' | \
	        grep -q '^$(IMAGE)$$' ; then \
	    docker build \
	        --tag=$(IMAGE) \
	        --cache-from=$(IMAGE) \
	        . ; \
	else \
	    docker build \
	        --tag=$(IMAGE) \
	        . ; \
	fi

push: build
	docker push $(IMAGE)

pull:
	docker pull $(IMAGE)

login:
	echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USERNAME) --password-stdin

.PHONY: all build push pull login

