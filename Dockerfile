FROM centos:7

RUN yum install epel-release -y && \
    yum install nginx gettext -y && \
    yum clean all && \
    mkdir -p /usr/share/nginx/html


COPY nginx.conf auth.htpasswd docker-entrypoint.sh ./

USER root
RUN chmod 777 /docker-entrypoint.sh
RUN chmod 777 /run /var/log/nginx
RUN chmod -R 777 /var/lib/nginx

EXPOSE 8080

USER 1001

CMD ["./docker-entrypoint.sh"]
