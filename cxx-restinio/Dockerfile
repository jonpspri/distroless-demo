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
#  Download restinio
#
ARG RESTINIO_VER=0.6.2
RUN wget -q \
    https://github.com/Stiffstream/restinio/releases/download/v.${RESTINIO_VER}/restinio-${RESTINIO_VER}-full.tar.bz2

#
#  Set up the build environment
#
RUN mkdir /build
COPY src /src

#
#  Copy Restinio into the source directory tree
#
RUN tar jxf restinio-${RESTINIO_VER}-full.tar.bz2 \
    --directory=/src restinio-${RESTINIO_VER}/dev/restinio --strip-components=2
RUN tar jxf restinio-${RESTINIO_VER}-full.tar.bz2 \
    --directory=/src restinio-${RESTINIO_VER}/dev/nodejs/http_parser --strip-components=2
RUN tar jxf restinio-${RESTINIO_VER}-full.tar.bz2 \
    --directory=/src restinio-${RESTINIO_VER}/dev/fmt --strip-components=2

#
#  Build the target executable
#
WORKDIR /build
RUN cmake -DRESTINIO_FIND_DEPS=ON -DRESTINIO_USE_BOOST_ASIO=static /src
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
