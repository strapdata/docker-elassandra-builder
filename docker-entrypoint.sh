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


main() {
  show_and_exec cd $SOURCE_DIR

  show_and_exec $MAVEN_CMD

  show_and_exec mkdir -p collect

  show_and_exec cp distribution/tar/target/releases/*.tar.gz collect/
  show_and_exec cp distribution/zip/target/releases/*.zip collect/
  show_and_exec cp distribution/deb/target/releases/*.deb collect/

  # temporary solution for renaming rpm file generated as elasticsearch-${version}.rpm
  for from in distribution/rpm/target/releases/elasticsearch*.rpm; do
    to=collect/$(echo $(basename $from) | sed -e 's/elasticsearch/elassandra/')
    show_and_exec cp $from $to
  done
}

main $@
