#!/bin/sh

[ -z "$LISTEN_PORT" ] && export LISTEN_PORT=8080

[ -z "$CACHE_MAX_SIZE" ] && export CACHE_MAX_SIZE=100m

[ -z "$CACHE_TTL" ] && export CACHE_TTL=24h

[ -z "$CACHE_KEYS_ZONE_SIZE" ] && export CACHE_KEYS_ZONE_SIZE=10m

[ -z "$CACHE_KEY_INACTIVE_TIME" ] && export CACHE_KEY_INACTIVE_TIME=60m

[ -z "$PROXY_BUFFERS_NUMBER" ] && export PROXY_BUFFERS_NUMBER=8

[ -z "$PROXY_BUFFERS_SIZE" ] && export PROXY_BUFFERS_SIZE=8k

[ -z "$PROXY_BUFFER_SIZE" ] && export PROXY_BUFFER_SIZE=16k

[ ! -z "${BASIC_AUTH_USERNAME}" ] && [ ! -z "${BASIC_AUTH_PASSWORD}" ] && \
    export HTPASSWD=$(htpasswd -bn "${BASIC_AUTH_USERNAME}" "${BASIC_AUTH_PASSWORD}")

envsubst '$${FORWARD_HOST} $${LISTEN_PORT} $${METRICS_PATH} $${CACHE_MAX_SIZE} $${CACHE_TTL} $${CACHE_KEYS_ZONE_SIZE} $${CACHE_KEY_INACTIVE_TIME} $${PROXY_BUFFERS_NUMBER} $${PROXY_BUFFERS_SIZE} $${PROXY_BUFFER_SIZE}' < nginx.conf > /tmp/nginx.conf
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
