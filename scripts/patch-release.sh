#!/bin/bash

function patch(){
  local latest_upstream=$1
  echo "patching... harvester-chart"
  sed -i "/tag:/c\  tag: $latest_upstream" helmfile.d/config/kusama-internal.yaml.gotmpl
}
