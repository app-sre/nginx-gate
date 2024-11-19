FROM ubi9/nginx-120

USER root

RUN mkdir -p /usr/share/nginx/html && \
    mkdir -p /var/cache/nginx

COPY nginx.conf auth.htpasswd container-entrypoint.sh ./

RUN chmod 777 ./docker-entrypoint.sh && \
    chmod 777 /run /var/log/nginx && \
    chmod -R 777 /var/lib/nginx && \
    chmod -R 777 /var/cache/nginx

VOLUME /tmp
VOLUME /var/cache/nginx

EXPOSE 8080

USER 1001

CMD ["./container-entrypoint.sh"]
