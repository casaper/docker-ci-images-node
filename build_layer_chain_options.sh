#!/usr/bin/env bash

. ./lib.sh

while test $# -gt 0; do
  package='build_layer_chain.sh'
  case "$1" in
  -h | --help)
    echo -e $'\n'"${BOLD}${package}${SET} - build a chain of docker image layers for node ci"$'\n'
    echo -e "${BOLD}Usage${SET}: ./$package [options]"
    echo -e ''
    echo -e "${BOLD}options:${SET}"$'\n'
    HELP_INDENT='                             '

    display_help_option "$HELP_INDENT" 'Show this help' 'h, --help'

    TEXT='Default is latest. See https://hub.docker.com/_/node for available base images.'
    display_help_option "$HELP_INDENT" "$TEXT" 'node-version' '=' 'latest'

    TEXT='Build layer with google-chrome-stable'
    display_help_option "$HELP_INDENT" "$TEXT" 'chrome'

    TEXT='Push all built tags to docker hub'$'\n'
    TEXT="${TEXT}${HELP_INDENT}See ${REPO_WEB_URL}"
    display_help_option "$HELP_INDENT" "$TEXT" 'push-to-hub'

    TEXT='Push the last built image as well as latest tag.'$'\n'
    TEXT="${TEXT}${HELP_INDENT}This enables --push-to-hub flag allongside"
    display_help_option "$HELP_INDENT" "$TEXT" 'push-last-as-latest'

    exit 0
    ;;
    # END of help output

  ## Option parsing and setting
  --node-version=*)
    NODE_VERSION_TAG="${1//--node-version=/}"
    echo "- base layer with ${NODE_VERSION_TAG}"
    shift
    ;;
  --chrome)
    BUILD_CHROME_LAYER="build"
    echo "-  Google Chrome stable layer"
    shift
    ;;
  --push-to-hub)
    PUSH_TO_HUB=1
    echo "- Pushing all built layers to docker hub"
    shift
    ;;
  --push-last-as-latest)
    PUSH_LAST_AS_LATEST=1
    PUSH_TO_HUB=1
    echo "- Pushing all built layers to docker hub"
    echo "- pushing last built as latest tag as well"
    shift
    ;;
  *)
    break
    ;;
  esac
done
