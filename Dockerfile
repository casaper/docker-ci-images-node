ARG docker_version_tag
FROM node:$docker_version_tag

LABEL name=docker-ci-images-node
LABEL version=0.0.2
LABEL build-date=2020-04-17T09:49:47.414Z
LABEL vendor=Panter maintainer=vok@panter.ch distribution-scope=private

RUN apt-get update \
  && apt-get install -y -q --no-install-recommends \
  git \
  # some clean up before finishing this layer
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean
