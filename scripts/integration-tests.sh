#!/bin/bash

source /scripts/common.sh
source /scripts/bootstrap-helm.sh

run_tests() {
    echo Running tests...

    wait_pod_ready harvester-api harvester
    wait_pod_ready explorer-api harvester
    wait_pod_ready explorer-gui harvester
}

teardown() {
    helmfile delete --purge
}

main(){
    if [ -z "$KEEP_W3F_HARVESTER" ]; then
        trap teardown EXIT
    fi

    kubectl create namespace harvester

    /scripts/build-helmfile.sh

    run_tests
}

main
