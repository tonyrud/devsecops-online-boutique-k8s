#!/bin/bash

SERVICE_NAME=${1?Error: no service name given}
VERSION=${2?Error: no version given}

yq -i "(.images[] | select(.name == \"$SERVICE_NAME\") | .newTag) = \"$VERSION\"" overlays/dev/kustomization.yaml