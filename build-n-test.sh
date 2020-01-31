#!/usr/bin/env bash

set -euo pipefail
scriptdir="$(dirname "$(realpath "$0")")"

#
#  TODO:  Take sleep duration as a script argument.  Make use of Java VM
#         image switchable (images to use as comma-seperated list?)
#
if [ "$(getopt -T)" == " --" ]; then
  echo "Not using the appropriate getopt.  Please obtain 'GNU getout'"; exit 255
fi
eval set -- "$(getopt -os:i: --longoptions sleep:,images: -n 'getopt' -- "$@")"

sleep_interval=5
images="cxx-crow cxx-restinio go java-quarkus-vm java-quarkus-native"
while true; do
  case "$1" in
    -s | --sleep) sleep_interval="$2"; shift; shift;;
    -i | --images) images=$(tr ',' ' ' <<<$2); shift; shift;;
    -- ) shift; break;;
    * ) break;;
  esac
done

#
#  Output goes into the log directory; I recommend using something like
#  `multitail` to watch the directory during build processing.
#
mkdir -p "$scriptdir/log"
for i in $images; do (
    echo "-------------------------------------------------------------------"
    echo "Building $i..."
    docker build -t "distroless-demo-$i" "$scriptdir/$i" >"$scriptdir/log/$i-build.out"

    echo "Running $i..."
    docker rm "$i" 2> /dev/null || :
    docker run --init --name="$i" -d -p 8080:8080 "distroless-demo-$i:latest"
    sleep $sleep_interval # TODO -- change this into a loop with faster checks?

    echo "Testing $i..."
    curl -si http://localhost:8080/api/hello || :; echo
    curl -si http://localhost:8080/bogus || :; echo

    echo "Cleaning $i..."
    docker rm -f "$i"
    echo "-------------------------------------------------------------------"
    echo
    echo
)| tee "$scriptdir/log/$i.out"; done
