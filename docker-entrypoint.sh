#!/bin/sh

[ -z "$LISTEN_PORT" ] && export LISTEN_PORT=8080

[ ! -z "${BASIC_AUTH_USERNAME}" ] && [ ! -z "${BASIC_AUTH_PASSWORD}" ] && \
    export HTPASSWD=$(htpasswd -bn "${BASIC_AUTH_USERNAME}" "${BASIC_AUTH_PASSWORD}")

envsubst '$${FORWARD_HOST} $${LISTEN_PORT}' < nginx.conf > /tmp/nginx.conf
envsubst < auth.htpasswd > /tmp/auth.htpasswd

nginx -c /tmp/nginx.conf
