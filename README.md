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
