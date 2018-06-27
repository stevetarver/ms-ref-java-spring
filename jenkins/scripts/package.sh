#!/usr/bin/env bash
#
# Package the app - build the docker image
#
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    # Run from project root
    cd ${MY_DIR}/../..

    mvn -DskipTests=true -Dspring.profiles.active=dev clean package

    if [[ $? -ne 0 ]]; then
        echo "mvn package failed"
        exit 1
    fi

    docker build \
        --build-arg GIT_REPO_NAME=${GIT_REPO_NAME}      \
        --build-arg GIT_BRANCH_NAME=${GIT_BRANCH_NAME}  \
        --build-arg BUILD_TIMESTAMP=${BUILD_TIMESTAMP}  \
        --build-arg GIT_COMMIT_HASH=${GIT_COMMIT_HASH}  \
        -f docker/Dockerfile                            \
        -t ${DOCKER_BUILD_IMAGE_NAMETAG}                \
        -t ${DOCKER_BUILD_IMAGE_NAMETAG_LATEST}         \
        .
)

