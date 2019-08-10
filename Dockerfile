FROM node:11-alpine
LABEL Maintainer="Hieupv <hieupv@codersvn.com>" \
  Description="Lightweight container for angular application on Alpine Linux."

# Install packages
RUN apk --no-cache add nginx supervisor curl bash git make


# Configure nginx
COPY ./.docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure supervisord
COPY ./.docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

# Setup document root
RUN mkdir -p /var/www/app

WORKDIR /var/www/app

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
