#!/usr/bin/env bash

set -euo pipefail
scriptdir="$(dirname "$(realpath "$0")")"

for i in cxx-crow cxx-restinio go java-quarkus; do (
    echo "-------------------------------------------------------------------"
    echo "Building $i..."
    # TODO Use parallel to speed this part up?
    docker build -t "distroless-demo-$i" "$scriptdir/$i" >"$scriptdir/log/$i-build.out"
    echo "Running $i..."
    docker rm "$i" 2> /dev/null || :
    docker run --init --name="$i" -d -p 8080:8080 "distroless-demo-$i:latest"
    sleep 5  # TODO -- change this into a loop with faster checks?
    curl -si http://localhost:8080/api/hello || :; echo
    curl -si http://localhost:8080/bogus || :; echo
    docker rm -f "$i"
    echo "-------------------------------------------------------------------"
)| tee "$scriptdir/log/$i.out"; done
