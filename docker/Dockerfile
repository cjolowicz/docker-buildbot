FROM alpine:3.9

RUN apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    python3-dev \
    su-exec

ENV BUILDBOT_VERSION 2.5.0
RUN pip3 --no-cache-dir install --upgrade pip && pip --no-cache-dir install \
    buildbot[bundle,tls]==$BUILDBOT_VERSION \
    buildbot-docker-swarm-worker

COPY buildbot.tac /var/lib/buildbot/
COPY docker-entrypoint.sh /usr/local/bin/
COPY master.cfg /etc/buildbot/

RUN adduser -h /var/lib/buildbot -D buildbot
WORKDIR /var/lib/buildbot
RUN ln -s /etc/buildbot/master.cfg

VOLUME /var/lib/buildbot
EXPOSE 8010
EXPOSE 9989

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["twistd", "--pidfile=", "--nodaemon", "--python=buildbot.tac"]
