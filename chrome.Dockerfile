# base image
#
# image tag for the image this one is based on
ARG base_image
FROM $base_image

LABEL name=docker-ci-images-node-chrome
LABEL version=0.0.2
LABEL build-date=2020-04-17T09:49:47.414Z
LABEL vendor=Panter maintainer=vok@panter.ch distribution-scope=private

# script for installing firefox and/or google chrome
ADD ./scripts /scripts

RUN /scripts/install_google_chrome.sh "install" \
      # some clean up before finishing this layer
      && rm -rf /var/lib/apt/lists/* \
      && apt-get clean
