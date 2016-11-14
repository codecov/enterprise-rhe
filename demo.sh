#!/bin/bash

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Starting Docker
sudo service docker start

# Retrieving droplet: Redis
docker run --name codecov-redis -d redis

# Retrieving Dockedroplet: Postgdropletes
docker run --name codecov-postgres -d postgres

# create config file
# Creating config file for Codecov: codecov.yml
ip=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | tail -1)
random=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1)

echo "# Documentation at http://docs.codecov.io/docs/install-guide
setup:
  codecov_url: http://$ip
  # enterprise_license: your_license_key_here
  cookie_secret: $random
" > codecov.yml

VERSION=":v4.1.3"

# Retrieving droplet: Codecov Enterprise
docker run -d -p 80:80 \
           --name codecov \
           --link codecov-redis:redis \
           --link codecov-postgres:postgres \
           -v "$PWD/codecov.yml:/codecov.yml" \
           "codecov/enterprise$VERSION"

echo "

  _____          _
 / ____|        | |
| |     ___   __| | ___  ___ _____   __
| |    / _ \\ / _\` |/ _ \\/ __/ _ \\ \\ / /
| |___| (_) | (_| |  __/ (_| (_) \\ V /
 \\_____\\___/ \\__,_|\\___|\\___\\___/ \\_/


Thank you for choosing Codecov!

Please navigate to http://$ip in your browser.

Your codecov.yml configuration file is located here
    $PWD/codecov.yml

Request a trial license to have full system access.
While in demo mode: you may only login with one user.
  and reports are deleted after 48 hours.

Thank you!
The Codecov Family

Email enterprise@codecov.io
"
