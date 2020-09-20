#
#  With thanks to https://codesahara.com/blog/building-a-hello-world-rest-api-in-go/
#
FROM golang:1.15.2-buster AS build

COPY helloworld.go /go/src/app/helloworld.go

RUN go get -d -v ./...
WORKDIR /go/src/app
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"'

#  Note -- this is a nonroot image
FROM gcr.io/distroless/static-debian10@sha256:9adc4c05db7f58534c64293b48d49fa5cbd198f2eb2c7b824b8088904588bc59

COPY --from=build /go/src/app/app /helloworld
EXPOSE 8080/tcp
CMD ["/helloworld"]
