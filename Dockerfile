FROM node:11-alpine AS builder

RUN apk add --no-cache python make g++

WORKDIR /var/www/app

COPY package*.json yarn*.lock ./

RUN sed -i '/\@vicoders\/generator/d' ./package.json && yarn install

COPY . .

RUN cat src/environments/environment.prod.ts > src/environments/environment.ts && yarn build_prod

FROM nginx:1.17-alpine

LABEL Maintainer="Hieupv <hieupv@codersvn.com>" \
  Description="Lightweight container for angular application on Alpine Linux."

RUN apk --no-cache add bash

COPY ./.docker/nginx/nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www/app


COPY --from=builder /var/www/app/dist ./dist
COPY --from=builder /var/www/app/package*.json /var/www/app/yarn* ./
