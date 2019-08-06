FROM node:11-alpine
LABEL Maintainer="Hieupv <hieupv@codersvn.com>" \
  Description="Lightweight container for angular application on Alpine Linux."

# Install packages
RUN apk --no-cache add nginx supervisor curl bash git make


# Configure nginx
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure supervisord
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/tmp/nginx && \
  chown -R nobody.nobody /var/log/nginx 

RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

# Setup document root
RUN mkdir -p /var/www/app

# Switch to use a non-root user from here on
USER nobody

WORKDIR /var/www/app

EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
