# Nginx Basic Auth Sidecar

Uses htpasswd.

## Build

```
$ docker build -t quay.io/app-sre/nginx-gate .
```

## Run

Given the user `foo` and the password `bar`, there are two ways to inject the
credentials:

 - Give the container the htpasswd content:

```
$ htpasswd -bn foo bar
foo:$apr1$00xPWwOg$sQRfZdrPbGiYz/qUPA8hX1
$ docker run --rm -it -e HTPASSWD='foo:$apr1$00xPWwOg$sQRfZdrPbGiYz/qUPA8hX1' -e FORWARD_HOST=example.com -p 8080:8080 ng
```

 - Give the container the username and password:

```
$ docker run --rm -it -e BASIC_AUTH_USERNAME='foo' -e BASIC_AUTH_PASSWORD='bar' -e FORWARD_HOST=example.com -p 8080:8080 ng
```

Note: When provided, `BASIC_AUTH_USERNAME` and `BASIC_AUTH_PASSWORD` will
have precedence over the `HTPASSWD` environment variable.

To disable authentication for the pod, use the env variable `BASIC_AUTH_DISABLE=true`

## Metrics

We allow an optional `METRICS_PATH` which will allow unauthenticated querying.
This can be useful to easily expose metrics for prometheus.

## Local Testing

A docker compose stack is provided that can be used to verify paths are forwarded as expected.
The compose stack starts multiple config flavors of the gate in parallel on different ports.

```
make compose
```

