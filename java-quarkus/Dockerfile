#
#  With thanks to https://quarkus.io/guides/getting-started
#
FROM adoptopenjdk:openj9 AS build
COPY getting-started /getting-started
WORKDIR /getting-started
RUN ./mvnw -B -Dquarkus.package.uber-jar=true package

FROM gcr.io/distroless/java:11
COPY --from=build \
  /getting-started/target/getting-started-1.0-SNAPSHOT-runner.jar \
  /getting-started-1.0-SNAPSHOT-runner.jar
CMD ["/getting-started-1.0-SNAPSHOT-runner.jar"]
