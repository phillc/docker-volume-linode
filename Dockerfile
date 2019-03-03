FROM golang:1.11.5-alpine as builder
ENV GO111MODULE=on
COPY . /src
WORKDIR /src
RUN apk update
RUN apk add git
RUN apk add --no-cache --virtual .build-deps gcc libc-dev
RUN go mod download
RUN go install --ldflags '-extldflags "-static"'
RUN apk del .build-deps
CMD ["/go/bin/docker-volume-linode"]

FROM alpine
COPY --from=builder /go/bin/docker-volume-linode .
RUN apk update && apk add ca-certificates e2fsprogs
CMD ["./docker-volume-linode"]
