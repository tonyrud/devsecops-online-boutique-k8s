#!/bin/bash

IMAGE_NAME=${1?Error: no service name given}
VERSION=${2?Error: no version given}

yq -i "(.images[] | select(.name == \"$IMAGE_NAME\") | .newTag) = \"$VERSION\"" apps/liveview_counter/envs/dev/dev/kustomization.yaml