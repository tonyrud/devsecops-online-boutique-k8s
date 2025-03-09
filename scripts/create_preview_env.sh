#!/bin/bash

# IMAGE_NAME=${1?Error: no service name given}
BRANCH_NAME=${1?Error: no branch name given}
# VERSION=${2?Error: no version given}

PREVIEW_DIR=overlays/liveview-counter/$BRANCH_NAME

mkdir -p $PREVIEW_DIR

cp -R overlays/liveview-counter/dev/. $PREVIEW_DIR

# update image tag
yq -i "(.images[] | select(.name == \"phoenix-liveview-counter\") | .newTag) = \"$BRANCH_NAME\"" $PREVIEW_DIR/kustomization.yaml

# update ingress host
yq -i "(.[0] | select(.path == \"/spec/rules/0/host\") | .value) = \"$BRANCH_NAME.tonyrudny.com\"" $PREVIEW_DIR/ingress-patches.yaml

# update namespace
yq -i "(.namespace) = \"$BRANCH_NAME\"" $PREVIEW_DIR/kustomization.yaml