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
    NAMESPACE='chaos'
    MINIKUBE_ENABLED=false
    if [[ "${K8S_CLUSTER_TYPE}" == 'minikube' ]]; then
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

# Facts & secrets not currently setup in our Jenkins server
#    helm upgrade --install --wait                                   \
#        --namespace=${NAMESPACE}                                    \
#        --set service.image.nameTag=${DOCKER_DEPLOY_IMAGE_NAMETAG}  \
#        --set service.version="v${BUILD_TIMESTAMP}"                 \
#        --set ingressLocations=${INGRESS}                           \
#        --set internalDomainName=${DOMAIN}                          \
#        --set minikube.enabled=${MINIKUBE_ENABLED}                  \
#        -f ${CONFIG_FILE}                                           \
#        -f ${SECRET_FILE}                                           \
#        ${DOCKER_PROJECT}                                           \
#        ./helm/ms-ref-java-spring
)