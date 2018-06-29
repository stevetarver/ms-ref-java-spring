#!/usr/bin/env bash
#
# Bring down the environment via docker-compose
#
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    cd ${MY_DIR}
    . ../../jenkins/config.sh

    docker-compose down
)

