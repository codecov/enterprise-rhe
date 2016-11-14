#!/bin/bash

VERSION="v4.1.3"

docker stop codecov || true
docker rm codecov || true

docker pull "codecov/enterprise:$VERSION"

docker run -d -p 80:80 \
           --name codecov \
           --link codecov-redis:redis \
           --link codecov-postgres:postgres \
           -v "$PWD/codecov.yml:/codecov.yml" \
           "codecov/enterprise:$VERSION"
