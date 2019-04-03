FROM alpine:3.9

RUN apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    python3-dev

ENV BUILDBOT_VERSION 1.8.0
RUN pip3 --no-cache-dir install --upgrade pip && pip --no-cache-dir install \
    buildbot[bundle,tls]==$BUILDBOT_VERSION \
    buildbot-docker-swarm-worker

COPY buildbot.tac /var/lib/buildbot/
COPY docker-entrypoint.sh /usr/local/bin/

RUN adduser -h /var/lib/buildbot -D buildbot
USER buildbot
WORKDIR /var/lib/buildbot

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["twistd", "--pidfile=", "--nodaemon", "--python=buildbot.tac"]
