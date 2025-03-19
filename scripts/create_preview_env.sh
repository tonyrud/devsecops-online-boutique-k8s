#!/bin/bash

set -e

BRANCH_NAME=${1?Error: no branch name given}
VERSION=${2?Error: no version given}
BASE_DIR=apps/liveview-counter/envs/dev
PREVIEW_DIR=$BASE_DIR/$BRANCH_NAME

mkdir -p $PREVIEW_DIR

cp -R $BASE_DIR/dev/. $PREVIEW_DIR

# update image tag
yq -i "(.images[] | select(.name == \"phoenix-liveview-counter\") | .newTag) = \"$VERSION\"" $PREVIEW_DIR/kustomization.yaml

INGRESS_HOST="$BRANCH_NAME.tonyrudny.com"

# update ingress host
yq -i "(.[0] | select(.path == \"/spec/rules/0/host\") | .value) = \"$INGRESS_HOST\"" $PREVIEW_DIR/ingress-patches.yaml

# update namespace
yq -i "(.namespace) = \"$BRANCH_NAME\"" $PREVIEW_DIR/kustomization.yaml

# set ENVs
# replaces dev.tonyrudny.com with $INGRESS_HOST

# THIS IS FOR MacOS:
# sed -i '' "s/dev.tonyrudny.com/$INGRESS_HOST/g" $PREVIEW_DIR/.env

case "$OSTYPE" in
  darwin*)  sed -i '' "s/dev.tonyrudny.com/$INGRESS_HOST/g" $PREVIEW_DIR/.env;; 
  *)        sed -i "s/dev.tonyrudny.com/$INGRESS_HOST/g" $PREVIEW_DIR/.env ;;
esac
