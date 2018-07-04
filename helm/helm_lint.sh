#!/usr/bin/env bash
#
# Lint the helm chart to resolve errors outside of Jenkins
#
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    cd ${MY_DIR}

    helm lint ms-ref-java-spring
)
