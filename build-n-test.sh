#!/usr/bin/env bash

set -euo pipefail
scriptdir="$(dirname "$(realpath "$0")")"

#
#  TODO:  Take sleep duration as a script argument.  Make use of Java VM
#         image switchable (images to use as comma-seperated list?)
#

#
#  Output goes into the log directory; I recommend using something like
#  `multitail` to watch the directory during build processing.
#
mkdir -p "$scriptdir/log"
for i in cxx-crow cxx-restinio go java-quarkus-native; do (
    echo "-------------------------------------------------------------------"
    echo "Building $i..."
    docker build -t "distroless-demo-$i" "$scriptdir/$i" >"$scriptdir/log/$i-build.out"

    echo "Running $i..."
    docker rm "$i" 2> /dev/null || :
    docker run --init --name="$i" -d -p 8080:8080 "distroless-demo-$i:latest"
    sleep 1  # TODO -- change this into a loop with faster checks?

    echo "Testing $i..."
    curl -si http://localhost:8080/api/hello || :; echo
    curl -si http://localhost:8080/bogus || :; echo

    echo "Cleaning $i..."
    docker rm -f "$i"
    echo "-------------------------------------------------------------------"
    echo
    echo
)| tee "$scriptdir/log/$i.out"; done
