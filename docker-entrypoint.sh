#!/bin/sh

[ -z "$LISTEN_PORT" ] && export LISTEN_PORT=8080

[ ! -z "${BASIC_AUTH_USERNAME}" ] && [ ! -z "${BASIC_AUTH_PASSWORD}" ] && \
    export HTPASSWD=$(htpasswd -bn "${BASIC_AUTH_USERNAME}" "${BASIC_AUTH_PASSWORD}")

envsubst '$${FORWARD_HOST} $${LISTEN_PORT} $${METRICS_PATH}' < nginx.conf > /tmp/nginx.conf
envsubst < auth.htpasswd > /tmp/auth.htpasswd

if [ "${BASIC_AUTH_DISABLE}" = "true" ]
then
    grep -v "auth_basic" /tmp/nginx.conf > /tmp/nginx_authless.conf
    rm /tmp/nginx.conf
    mv /tmp/nginx_authless.conf /tmp/nginx.conf
fi

if [ -z "${METRICS_PATH}" ]
then
    grep -v "# METRICS_MARKER" /tmp/nginx.conf > /tmp/nginx_metricless.conf
    rm /tmp/nginx.conf
    mv /tmp/nginx_metricless.conf /tmp/nginx.conf
fi

nginx -c /tmp/nginx.conf
