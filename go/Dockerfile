#
#  With thanks to https://codesahara.com/blog/building-a-hello-world-rest-api-in-go/
#
FROM golang:1.13.5 AS build

COPY helloworld.go /go/src/app/helloworld.go

RUN go get -d -v ./...
WORKDIR /go/src/app
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"'

FROM gcr.io/distroless/static:nonroot

COPY --from=build /go/src/app/app /helloworld
EXPOSE 8080/tcp
CMD ["/helloworld"]