#
#  With thanks to https://www.quora.com/How-do-I-create-a-simple-REST-API-with-C-or-C++
#
FROM s390xopenwhisk/boost-builder:1.69.0 AS build

SHELL [ "/bin/bash", "-euo", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    git \
    make \
    && rm -rf /var/lib/apt/lists/*

#
#  Set up the build environment
#
RUN mkdir /build
COPY src /src
WORKDIR /src
RUN git clone https://github.com/ipkn/crow.git

#
#  Build the target executable
#
WORKDIR /build
RUN cmake /src
RUN make

#
#  At this point, everything is built.  The remaining steps configure this
#  container image so it can be used for quick-and-dirty unit testing
#
RUN ls -l hello && (ldd hello ||:)

FROM us.icr.io/openwhisk-multiarch/distroless_base:static-nonroot_debian10
#FROM gcr.io/distroless/static:nonroot

# Add the app
COPY --from=build /build/hello /hello
EXPOSE 8080
CMD ["/hello"]
