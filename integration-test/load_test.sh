#!/usr/bin/env bash
#
# Provide some load on the system
# See how much load with: docker stats <container_id>
#
# With 10 clients running 100 tests (8000 requests) on my mac
# max cpu: 393% (4 cores or 4000m)
# max mem: 91MiB
# avg req duration: 47ms
#
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    cd ${MY_DIR}

    for i in {1..10}; do
        ( ./run.sh -n 100 -t smoke -e local.compose & )
    done
)
