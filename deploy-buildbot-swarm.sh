#!/bin/bash

set -euo pipefail

if [ $# -gt 0 ]
then
    case $1 in
        '--remove' | '--rm')
            set +e -x

            docker-machine ssh manager "docker stack rm buildbot"
            docker-machine rm -f worker
            docker-machine rm -f manager

            exit
            ;;
    esac

    echo "unrecognized option \`$1'" >&2
    exit 1
fi

set -x

docker-machine create --driver virtualbox manager
docker-machine create --driver virtualbox worker

manager_ip=$(docker-machine ls --format='{{.URL}}' --filter='name=manager' |
         sed -e 's,^tcp://,,' -e 's/:[^:]*$//')

eval $(docker-machine env manager)

docker swarm init --advertise-addr $manager_ip

token=$(docker swarm join-token --quiet worker)

(
    eval $(docker-machine env worker)
    docker swarm join --token $token $manager_ip:2377
)

docker stack deploy -c docker-compose.yml buildbot
docker service ls
