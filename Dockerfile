FROM node:erbium-alpine

LABEL maintainer Kaspar Vollenweider

RUN apk --update add git openssh && \
  rm -rf /var/lib/apt/lists/* && \
  rm /var/cache/apk/*
