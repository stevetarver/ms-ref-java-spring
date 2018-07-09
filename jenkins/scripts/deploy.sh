#!/usr/bin/env bash
#
# Deploy our helm chart to the dev/pre-prod environment
#
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    # Run from project root
    cd ${MY_DIR}/../..

    INGRESS='{us-east}'
    DOMAIN='makara.dom'

    case ${TARGET_ENV} in
        'dev')
            NAMESPACE='chaos'
            ;;

        'pre-prod')
            NAMESPACE='pre-prod'
            ;;

        'prod')
            NAMESPACE='prod'
            ;;

            *)
            echo "Unknown TARGET_ENV: ${TARGET_ENV}"
            exit 1
            ;;
    esac

    MINIKUBE_ENABLED=false
    if [[ "${K8S_CLUSTER_TYPE}" == "minikube" ]]; then
        MINIKUBE_ENABLED=true
    fi

    echo "********** Deploying ${DOCKER_DEPLOY_IMAGE_NAMETAG} to ${NAMESPACE} **********"

    helm upgrade --install --wait                                   \
        --namespace=${NAMESPACE}                                    \
        --set service.image.nameTag=${DOCKER_DEPLOY_IMAGE_NAMETAG}  \
        --set service.version="v${BUILD_TIMESTAMP}"                 \
        --set ingressLocations=${INGRESS}                           \
        --set internalDomainName=${DOMAIN}                          \
        --set minikube.enabled=${MINIKUBE_ENABLED}                  \
        ${DOCKER_PROJECT}                                           \
        ./helm/ms-ref-java-spring
)
