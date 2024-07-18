# syntax=docker/dockerfile:1.4

FROM golang:1.22.0-alpine3.19 AS build-dev
WORKDIR /go/src/app
COPY --link go.mod go.sum ./
RUN apk --update add --no-cache upx gcc musl-dev || \
    go version && \
    go mod download
COPY --link . .
ENV GOCACHE=/root/.cache/go-build
RUN --mount=type=cache,target="/root/.cache/go-build" CGO_ENABLED=1 go install -buildvcs=false -trimpath -ldflags '-w -s -extldflags "-static"'
RUN [ -e /usr/bin/upx ] && upx /go/bin/go-sqlite3-crossbuild-example || echo
FROM scratch
COPY --link --from=build-dev /go/bin/go-sqlite3-crossbuild-example /go/bin/go-sqlite3-crossbuild-example
CMD ["/go/bin/go-sqlite3-crossbuild-example"]
