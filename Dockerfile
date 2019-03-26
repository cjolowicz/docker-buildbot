FROM alpine:3.9

RUN apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    python3-dev

ENV BUILDBOT_VERSION 1.8.0
RUN pip3 --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install docker && \
    pip --no-cache-dir install buildbot[bundle,tls]==$BUILDBOT_VERSION

WORKDIR /var/lib/buildbot

COPY buildbot.tac .
COPY master.cfg .
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["twistd", "--pidfile=", "--nodaemon", "--python=buildbot.tac"]
