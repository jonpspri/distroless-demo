#
#  With thanks to https://quarkus.io/guides/getting-started
#   and https://quarkus.io/guides/building-native-image
#
FROM ubuntu:bionic AS build

SHELL [ "/bin/bash", "-euo", "pipefail", "-c"]

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      ca-certificates \
      curl \
      build-essential libz-dev zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

ENV GRAALVM_VERSION=19.3.1 \
    GRAALVM_GITHUB_PROJECT=graalvm/graalvm-ce-builds \
    GRAALVM_JAVA="java11-"

RUN arch="$(uname -m | sed -e 's/x86_64/amd64/')" \
 && curl -sL "https://github.com/${GRAALVM_GITHUB_PROJECT}/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-${GRAALVM_JAVA}linux-${arch}-${GRAALVM_VERSION}.tar.gz" |  tar zfxv -
ENV GRAAL_HOME="/graalvm-ce-${GRAALVM_JAVA}${GRAALVM_VERSION}"
ENV JAVA_HOME="${GRAAL_HOME}" \
    PATH="${GRAAL_HOME}/bin:$PATH"
RUN "${GRAAL_HOME}/bin/gu" install native-image

COPY getting-started /getting-started
WORKDIR /getting-started
RUN ./mvnw -B package -Pnative

#
#  Learn more about this image at
#  https://github.com/quarkusio/quarkus-images/tree/master/distroless
#
FROM cescoffier/native-base@sha256:407e2412c7d15ee951bfc31dcdcbbba806924350734e9b0929a95dd16c7c1b2b
COPY --from=build \
  /getting-started/target/getting-started-1.0-SNAPSHOT-runner \
  /getting-started-1.0-SNAPSHOT-runner
CMD ["/getting-started-1.0-SNAPSHOT-runner"]
