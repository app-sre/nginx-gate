#!/bin/sh

[ -z "$LISTEN_PORT" ] && export LISTEN_PORT=8080

envsubst '$${FORWARD_HOST}' < nginx.conf > /tmp/nginx.conf
envsubst '$${LISTEN_PORT}' < nginx.conf > /tmp/nginx.conf
envsubst < auth.htpasswd > /tmp/auth.htpasswd

nginx -c /tmp/nginx.conf
