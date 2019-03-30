FROM alpine:3.9

RUN apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    python3-dev

ENV BUILDBOT_VERSION 1.8.0
RUN pip3 --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install 'https://github.com/cjolowicz/buildbot-docker-swarm-worker/archive/master.zip' && \
    pip --no-cache-dir install buildbot[bundle,tls]==$BUILDBOT_VERSION

WORKDIR /var/lib/buildbot

COPY buildbot.tac /usr/local/lib
COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex; \
    adduser -h /var/lib/buildbot -D buildbot; \
    chown -R buildbot /var/lib/buildbot

USER buildbot

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["twistd", "--pidfile=", "--nodaemon", "--python=/usr/local/lib/buildbot.tac"]
