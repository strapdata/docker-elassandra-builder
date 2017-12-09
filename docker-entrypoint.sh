#!/usr/bin/env bash

# Compile the maven project located in $SOURCE_DIR
# and put distribution files in the $SOURCE_DIR/collect directory

set -e

GREEN='\033[1;32m'
RED='\033[1;31m'
MAGENTA='\033[1;35m'
NOCOLOR='\033[0m'
CYAN='\033[1;36m'
NOCOLOR='\033[0m'

echo_color() {
    color="$1"
    shift
    text="$@"
    echo -e "[${color}$text${NOCOLOR}]";
}

show_and_exec(){
  echo_color $CYAN "$@"
  eval "$@"
}

package() {
  show_and_exec cd $SOURCE_DIR

  show_and_exec $GRADLE_CMD

  if [ "$FIX_OWNERSHIP" = "true" ]; then

    if [ -n "$FIXED_OWNER" ] && [ -n "$FIXED_GROUP" ]; then
      show_and_exec find -type d -name 'target' -exec chown -R $FIXED_OWNER:$FIXED_GROUP {} '\;'
    else
        echo_color $RED "Missing environmment variables FIXED_OWNER and FIXED_GROUP"
        exit 1
    fi
  fi
}

case $1 in
  package)
    package
    ;;
  *)
    show_and_exec "$@"
    ;;
esac
