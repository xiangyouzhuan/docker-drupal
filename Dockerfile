FROM dokken/centos-stream-9

RUN yum install -y php php-bcmath php-fpm php-gd php-intl php-mbstring php-mysqlnd php-opcache php-pdo php-pecl-apcu php-devel
RUN yum install -y nginx
RUN dnf install -y mysql-server

RUN mkdir -p /data/web/test.drupal.com
COPY drupal-9.5.11 /data/web/test.drupal.com
RUN chown -R apache:nginx /data/web/test.drupal.com
RUN chmod -R 755 /data/web/test.drupal.com


COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /etc/nginx/conf.d
COPY default.conf /etc/nginx/conf.d/default.conf
COPY test.drupal.com.conf /etc/nginx/conf.d/test.drupal.com.conf

RUN mkdir -p /run/php-fpm/

RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh
RUN echo 'nginx -c /etc/nginx/nginx.conf'>> /usr/local/bin/docker-entrypoint.sh
RUN echo 'nginx -t && nginx -s reload'>> /usr/local/bin/docker-entrypoint.sh
RUN echo '/usr/sbin/php-fpm --nodaemonize &'>> /usr/local/bin/docker-entrypoint.sh
RUN echo 'while true; do sleep 100; done;' >> /usr/local/bin/docker-entrypoint.sh

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]


