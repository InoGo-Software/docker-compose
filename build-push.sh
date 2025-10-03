#!/bin/bash
# Usage: ./build-push.sh <version>
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi
VERSION="$1"

docker build -t inogo/docker-compose:$VERSION .
docker push inogo/docker-compose:$VERSION
