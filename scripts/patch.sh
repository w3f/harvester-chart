#!/bin/bash
set -e

echo Patching...

sed -i "/tag:/c\  tag: $latest_upstream" helmfile.d/config/kusama-internal.yaml.gotmpl
