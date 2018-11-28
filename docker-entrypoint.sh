#!/bin/sh

envsubst '$${FORWARD_HOST}' < nginx.conf > /tmp/nginx.conf
envsubst < auth.htpasswd > /tmp/auth.htpasswd

nginx -c /tmp/nginx.conf
