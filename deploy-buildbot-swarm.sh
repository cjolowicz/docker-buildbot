#!/bin/bash

set -euo pipefail

function create() {
    docker-machine create --driver virtualbox manager
    docker-machine create --driver virtualbox worker

    manager_ip=$(docker-machine ip manager)

    eval $(docker-machine env manager)

    docker swarm init --advertise-addr=$manager_ip

    token=$(docker swarm join-token --quiet worker)

    (
        eval $(docker-machine env worker)
        docker swarm join --token=$token $manager_ip:2377
    )

    docker stack deploy --compose-file=docker-compose.yml buildbot
    docker service ls
}

function remove() {
    docker-machine ssh manager "docker stack rm buildbot"
    docker-machine rm -f worker
    docker-machine rm -f manager
}

if [ $# -eq 0 ]
then
    set -x
    create
else
    case $1 in
        '--remove' | '--rm')
            set -x +e
            remove
            ;;

        *)
            echo "unrecognized option \`$1'" >&2
            exit 1
            ;;
    esac
fi
