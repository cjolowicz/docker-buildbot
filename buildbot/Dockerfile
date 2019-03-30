FROM alpine:3.9

RUN apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    python3-dev

ENV BUILDBOT_DOCKER_SWARM_WORKER_COMMIT 912751162efe3fc573ce6d92e1c2db3317252a19
ENV BUILDBOT_VERSION 1.8.0
RUN pip3 --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install https://github.com/cjolowicz/buildbot-docker-swarm-worker/archive/$BUILDBOT_DOCKER_SWARM_WORKER_COMMIT.zip && \
    pip --no-cache-dir install buildbot[bundle,tls]==$BUILDBOT_VERSION

COPY buildbot.tac /usr/local/lib
COPY docker-entrypoint.sh /usr/local/bin/

RUN adduser -h /var/lib/buildbot -D buildbot
USER buildbot
WORKDIR /var/lib/buildbot

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["twistd", "--pidfile=", "--nodaemon", "--python=/usr/local/lib/buildbot.tac"]
