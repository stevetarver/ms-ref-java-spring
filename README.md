## Overview

This repo provides a reference cloud-native microservice implementing best practices described in [my blog](http://stevetarver.github.io/):

* Code
    * Request validation
    * Flat response bodies for service to service communication
    * Rich json:api error responses
    * Healthz endpoints: liveness, readiness, and ping
* Build
    * Unit tests and code coverage
    * Integration tests
    * Custom CI docker image
    * Helm chart
* Operations
    * Smoke test
    * Structured logging implementing the [logging standard](https://github.com/CenturyLinkCloud/pl-cloud-infrastructure/wiki/Standard:-Logging)
    * Metrics using the Prometheus standard
    * **TODO** Distributed tracing using Jaeger client libraries

Each of the reference projects may be run:

* from the command line
* as a compiled unit (where applicable)
* from a docker image
* in minikube
* in a standard Kubernetes deployment

Implementation notes for each facility are in the `doc` directory.

## Project structure

All reference projects have, at project root:

* `/docker/{repo-name}`: Dockerfiles and related files
* `/helm/{repo-name}`: Helm templated kubernetes manifests
* `/jenkins/scripts`: Build scripts that implement pipeline stages
* `/jenkins/config`: Jenkins job config.xml files for each cluster
* `Jenkinsfile`: The standard Jenkins pipeline and configuration
* `/src`: All source code

## Project setup

### IntelliJ Setup

1. Install the Lombok plugin

### Maven setup

To run clover locally, add this to your `~/.m2/settings.xml`:

```xml
    <pluginGroups>
        <pluginGroup>org.openclover</pluginGroup>
    </pluginGroups>
```

## Running locally

Each reference service uses datastores from the [sample-data repo](https://github.com/stevetarver/sample-data).

### Java app in IDE

For local development and tinkering, you can run the service from the IDE or command line but you will need to build and run the MongoDb contacts datastore:

1. Clone the [sample-data repo](https://github.com/stevetarver/sample-data)
1. `cd docker`
1. `./build.sh build mongo`
1. `./build.sh run mongo`

Run the service in the IDE or from the command line:

```
./run.dev.sh
```

### docker-compose

To bring both this service and the MongoDB backend up on your local machine

```
ᐅ ./integration-test/local/compose_up.sh
===> Bringing up our java service and mongo with docker compose
Creating network "local_default" with the default driver
Creating ms-ref-java-spring-mongodb ... done
Creating ms-ref-java-spring-mongodb ...
===> It will take a bit for mongo to complete its initialization... but when complete
===> ms-ref-java-spring is at http://localhost:8080
===> and MongoDB is at mongodb://localhost:27117
===> Opening a browser showing contacts
```

Notes:

* If no local image exists with tag `latest`, one will be built.
* If you want the docker image to refelect current code: `./integration-test/local/docker_clean.sh`

To bring this environment down:

```
ᐅ ./integration-test/local/compose_down.sh
Stopping ms-ref-java-spring-service ... done
Stopping ms-ref-java-spring-mongodb ... done
Removing ms-ref-java-spring-service ... done
Removing ms-ref-java-spring-mongodb ... done
Removing network local_default
```

This stops and removes containers created during `compose_up.sh`.

### minikube

To get started with minikube and helm, look through the instructions at `ms-ref-java-spring/doc/install_k8s_and_helm_locally.md`.

1. Start minikube: `minikube start`
1. Deploy to minikube: `./integration-test/local/minikube_install.sh`
4. Delete from minikube `./integration-test/local/minikube_delete.sh`
1. Stop minikube: `minikube stop`

Notes:

* You will be asked for portr creds during `minikube_install.sh`
* The script will open the minikube Kubernetes dashboard for you
* The script will open a browser to the `/contacts` collection
* The script will print out urls for the service and datastore

### To run unit tests and coverage in the CI container

To run unit tests and clover in your CI image:

```
./integration-test/local/unit_test_in_docker_container.sh
```

This will print output in the shell; really handy for proving/debugging CI containers prior to pushing them to portr.


