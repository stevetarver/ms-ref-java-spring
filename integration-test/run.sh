#!/usr/bin/env bash
#
# Run an integration test on the api/datastore
#
# Return non-zero on any non-successful call of this script
#
# NOTE: requires newman >= 3.9.3 for advanced postman features we are using
#

show_help() {
    echo
    echo "Usage: run.sh [-hqb] [-d delay] [-t test] [-e environment] [-n count]"
    echo
    echo "Run integration tests against an environment"
    echo
    echo "Options:"
    echo "  -h, --help               Show this help message and exit."
    echo "  -b, --bail               Stop tests on first failure."
    echo "  -c, --color              Print cli output using color. Default on for local envs."
    echo "  -d, --delay delayMillis  Delay this many milliseconds between requests. Default = 0."
    echo "  -e, --env environment    Run against one of: 'local.native' 'local.compose' 'local.minikube'"
    echo "                           Default = local.native"
    echo "  -n, --count iterations   Run this many iterations. Default = 1."
    echo "  -q, --quiet              Display nothing on the console; rely on exit code."
    echo "  -t, --test test          Run one of: smoke, integration, regression test. Default = smoke."
    echo
    echo "Examples:"
    echo "  Local testing"
    echo "  ./run.sh -n 10 -t smoke -e local.compose   Running service through local/compose_up.sh"
    echo "                                             Run the smoke test, 10 time."
    echo "  ./run.sh -r -t integration -e local.native Running service through IDE or command line with mongo available."
    echo "                                             Run the integration test, one time, open report when complete."
    echo "  ./run.sh -t integration -e local.minikube  Running service through local/minikube_deploy.sh"
    echo "                                             Run the integration test, one time."
    echo
    echo "  Jenkins integration tests"
    echo "  ./run.sh -q -b -t integration -e dev.ops    integration test for dev using vpn (internal endpoint)"
    echo "  ./run.sh -q -b -t smoke -e dev.public       smoke test the public api in dev"
    echo "  ./run.sh -q -b -t integration -e prod.ops   prod-test stage for prod"
    echo
    echo "  Other"
    echo "  ./run.sh -t smoke -e dev.ops Run the smoke test against dev, one time."
    echo
}

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    # ensure we are in local dir for relative paths
    cd ${MY_DIR}

    # pull in common defs for terminal colors and fatal()
    . common.sh

    # defaults
    TEST='smoke'
    ENVIRONMENT='local.native'
    ITERATIONS=1
    OPTIONS='--reporters html,cli'
    NUMBER_RE='^[0-9]+$'

    VALID_TESTS=('smoke' 'integration' 'regression')
    VALID_ENVS=('local.native' 'local.compose' 'local.minikube')

    OPEN_REPORT=0

    while [[ $# -gt 0 ]]; do
        key="$1"
        case ${key} in
            -h|--help)
                show_help
                # It is an error to ask for help ;) - want all calls that don't result in a
                # successful test to return a non-zero exit code.
                exit 1
                ;;

            -q|--quiet)
                OPTIONS="${OPTIONS} --silent "
                ;;

            -b|--bail)
                OPTIONS="${OPTIONS} --bail "
                ;;

            -c|--color)
                OPTIONS="${OPTIONS} --color "
                ;;

            -d|--delay)
                if [[ $2 =~ ${NUMBER_RE} ]]; then
                    OPTIONS="${OPTIONS} --delay-request $2 "
                else
                    fatal "Not a valid integer for -n: '$2'"
                fi
                shift # past argument
                ;;

            -t|--test)
                if [[ " ${VALID_TESTS[@]} " =~ " $2 " ]]; then
                    TEST=$2
                else
                    fatal "Not a valid test: '$2'"
                fi
                shift # past argument
                ;;

            -e|--env)
                if [[ " ${VALID_ENVS[@]} " =~ " $2 " ]]; then
                    ENVIRONMENT=$2
                else
                    fatal "Not a valid environment: '$2'"
                fi
                shift # past argument
                ;;

            -n|--count)
                if [[ $2 =~ ${NUMBER_RE} ]]; then
                   ITERATIONS=$2
                else
                    fatal "Not a valid integer for -n: '$2'"
                fi
                shift # past argument
                ;;

            -r|--report)
                OPEN_REPORT=1
                ;;

            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
        shift # past argument or value
    done

    # cli reporter defaults produce color. If we are not running against a local environment,
    # turn that off unless the caller specifically turned it on.
    if [[ ${ENVIRONMENT} != local*  &&  ${OPTIONS} != *--color* ]]; then
        OPTIONS="${OPTIONS} --no-color "
    fi

    CMD="postman/test.${TEST}.json ${OPTIONS} -n ${ITERATIONS} -e postman/env.${ENVIRONMENT}.json"

    echo "Running: newman run $CMD"
    newman run ${CMD}
    exit_code=$?

    if [[ "${OPEN_REPORT}" -eq "1" ]]; then
        # open most recent test
        test_file=$(ls newman | tail -n 1)
        open newman/${test_file}
    fi

    if [[ ${exit_code} -ne 0 ]]; then
        fatal "newman test had failures"
    fi
)
