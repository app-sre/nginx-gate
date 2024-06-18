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

## Cache configuration

The Nginx proxy is also configured for caching GraphQL response. Some key details about caching are listed below

* The caching strategy used is LRU ( Least Recently Used ) by setting a long `CACHE_TTL` value and let Nginx delete unused cache items.
* Configurations that can be set via env vars are listed below
  * `CACHE_TTL`: This defined how long the response is cached for. For more info see  [proxy_cache_valid](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_valid) directive.
  * `CACHE_MAX_SIZE`: This defines the maximum size allocated for cache. 
  * `CACHE_KEYS_ZONE_SIZE`: This defines the size allocated for storing cache keys. For more info see [proxy_cache_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive.
  * `CACHE_KEY_EXPIRATION_TIME`: This defines the inactive period for cache keys. i.e cache keys are not accessed during the time specified by the inactive parameter get removed from the cache regardless of their freshness. For more info see [proxy_cache_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) directive.
* To skip cache, use header `X-Skip-Cache` with any value
* The server responds with header `X-Cache-Status` with the values `MISS`, `BYPASS`, `EXPIRED`, `STALE`, `UPDATING`, `REVALIDATED`, or `HIT` from `$upstream_cache_status` parameter. More info in [upstream](https://nginx.org/en/docs/http/ngx_http_upstream_module.html) module.  

### To test the caching setup
* Run qontract-server locally.
* `make compose` to run nginx-gate setup.
* Update qontract-reconcile config to point to any of the nginx container running at port 8081, 8082 or 8083. And run any of the integrations in dry-run mode.
  ```
    [graphql]
    server = "http://localhost:8082/graphql"
    ```
