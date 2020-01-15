#
#  With thanks to https://quarkus.io/guides/getting-started
#
FROM adoptopenjdk:openj9 AS build

SHELL [ "/bin/bash", "-euo", "pipefail", "-c"]

ENV GRAALVM_VERSION=19.3.1 \
    GRAAL_HOME="/graalvm-ce-java11-${GRAALVM_VERSION}" \
    JAVA_HOME=${GRAALVM_HOME} \
    PATH=${GRAALVM_HOME}/bin:$PATH

WORKDIR /
RUN curl -sL https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz \
  | tar zfxv -
RUN env
RUN "${GRAAL_HOME}/bin/gu" install native-image

COPY getting-started /getting-started
WORKDIR /getting-started
RUN ./mvnw -B -Dquarkus.package.uber-jar=true package

FROM gcr.io/distroless/java:11
COPY --from=build \
  /getting-started/target/getting-started-1.0-SNAPSHOT-runner.jar \
  /getting-started-1.0-SNAPSHOT-runner.jar
CMD ["/getting-started-1.0-SNAPSHOT-runner.jar"]
