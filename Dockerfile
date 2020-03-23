FROM golang:alpine AS build-env

ENV GO111MODULE=on \
    CGO_ENABLED=0

ADD . /src
WORKDIR /src

RUN go mod download
RUN go test ./...
RUN go build cmd/apcupsd_exporter/main.go

FROM alpine:latest

COPY --from=build-env /src/main /apcupsd_exporter

EXPOSE 9162

USER nobody:nobody

ENTRYPOINT ["/apcupsd_exporter"]
