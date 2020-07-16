#!/bin/bash
set -e


patch(){
 local LATEST_UPSTREAM=$1

 sed -i "/tag:/c\  tag: $LATEST_UPSTREAM" helmfile.d/config/kusama-internal.yaml.gotmpl
}
