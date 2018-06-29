#!/usr/bin/env bash
#
# Start the service and datastore containers through docker-compose
#
# Example mongo docker start command
#    docker run --name $CONTAINER_NAME   \
#        -p 27017:27017                  \
#        --restart=always                \
#        -d $IMAGE_NAME
#
# Example falcon docker start command
#    docker run --name $CONTAINER_NAME \
#                -p 8080:8080          \
#                --restart=always      \
#                -d $IMAGE_NAME
#
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    cd ${MY_DIR}
    . ../../jenkins/config.sh

    if [[ "$(docker images -q ${DOCKER_BUILD_IMAGE_NAMETAG_LATEST} 2> /dev/null)" = "" ]]; then
        echo "${ECHO_PREFIX} Building a fresh docker container"
        ./build_service_image.sh
    fi

    echo "${ECHO_PREFIX} Bringing up our java service and mongo with docker compose"
    docker-compose up -d
    if [[ $? -ne 0 ]]; then
        echo "Docker build failed"
        exit 1
    fi
    sleep 10

    echo "${ECHO_PREFIX} It will take a bit for mongo to complete its initialization... but when complete"
    echo "${ECHO_PREFIX} ${DOCKER_PROJECT} is at http://localhost:8080"
    echo "${ECHO_PREFIX} and MongoDB is at mongodb://localhost:27117"
    echo "${ECHO_PREFIX} Opening a browser showing contacts"
    open http://localhost:8080/reference/java/contacts

)