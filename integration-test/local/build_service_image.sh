#!/usr/bin/env bash
#
# Build this project's docker image locally for local testing.
# This should be kept in sync with jenkins/scripts/package.sh
#
# NOTE: you should not push this image to portr - it was created
#       outside the jenkins pipeline
#
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    # Run from project root
    cd ${MY_DIR}/../..
    . jenkins/config.sh

    mvn -DskipTests=true clean package

    if [[ $? -ne 0 ]]; then
        echo "mvn package failed"
        exit 1
    fi

    docker build \
        -f docker/Dockerfile                            \
        --build-arg GIT_REPO_NAME=${GIT_REPO_NAME}      \
        --build-arg GIT_BRANCH_NAME=${GIT_BRANCH_NAME}  \
        --build-arg BUILD_TIMESTAMP=${BUILD_TIMESTAMP}  \
        --build-arg GIT_COMMIT_HASH=${GIT_COMMIT_HASH}  \
        -t ${DOCKER_BUILD_IMAGE_NAMETAG}                \
        -t ${DOCKER_BUILD_IMAGE_NAMETAG_LATEST}         \
        .
)

