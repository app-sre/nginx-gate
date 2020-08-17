# Nginx Basic Auth Sidecar

Uses htpasswd.

## Build

```
$ docker build -t quay.io/app-sre/nginx-gate .
```

## Run

```
$ htpasswd -bn foo bar
foo:$apr1$00xPWwOg$sQRfZdrPbGiYz/qUPA8hX1
$ docker run --rm -it -e HTPASSWD='foo:$apr1$00xPWwOg$sQRfZdrPbGiYz/qUPA8hX1' -e FORWARD_HOST=example.com -p 8080:8080 ng
```
