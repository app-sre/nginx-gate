FROM quay.io/centos/centos:8


RUN yum install epel-release -y && \
    yum install nginx gettext httpd-tools -y && \
    yum clean all && \
    mkdir -p /usr/share/nginx/html && \
    mkdir -p /var/cache/nginx


COPY nginx.conf auth.htpasswd docker-entrypoint.sh ./

USER root
RUN chmod 777 /docker-entrypoint.sh && \
    chmod 777 /run /var/log/nginx && \
    chmod -R 777 /var/lib/nginx && \
    chmod -R 777 /var/cache/nginx

VOLUME /tmp
VOLUME /var/cache/nginx

EXPOSE 8080

USER 1001

CMD ["./docker-entrypoint.sh"]
