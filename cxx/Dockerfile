FROM ubuntu:bionic AS build

SHELL [ "/bin/bash", "-euo", "pipefail", "-c"]

#
#  Note that this may need to have lines added for OpenSSL, PCRE, PCRE2,
#  and Boost:Regex libraries to make certain features of Restinio available.
#
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    software-properties-common \
 && add-apt-repository ppa:mhier/libboost-latest \
 && apt-get update \
 && apt-get -y --no-install-recommends install \
    ca-certificates \
    cmake \
    libboost1.70-dev \
    libc6-dev \
    libpcre2-dev \
    libpcre3-dev \
    libssl1.0-dev \
    g++ \
    make \
    wget \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* \
 && :

#
#  Download restinio
#
ARG RESTINIO_VER=0.5.1.2
RUN wget -q https://bitbucket.org/sobjectizerteam/restinio/downloads/restinio-0.5.1.2-full.tar.bz2

#
#  Set up the build environment
#
RUN mkdir /build
COPY src /src

#
#  Copy Restinio into the source directory tree
#
RUN tar jxf restinio-${RESTINIO_VER}-full.tar.bz2 --directory=/src restinio-${RESTINIO_VER}/dev/restinio --strip-components=2
RUN tar jxf restinio-${RESTINIO_VER}-full.tar.bz2 --directory=/src restinio-${RESTINIO_VER}/dev/nodejs/http_parser --strip-components=2
RUN tar jxf restinio-${RESTINIO_VER}-full.tar.bz2 --directory=/src restinio-${RESTINIO_VER}/dev/fmt --strip-components=2

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
RUN ls -l hello && ldd hello

FROM gcr.io/distroless/cc:22bd467b41e5e656e31db347265fae118db166d9

# Add the app
COPY --from=build /build/hello /hello
EXPOSE 8080
CMD ["/hello"]
