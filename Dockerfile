############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git
WORKDIR /root/cloud-torrent
RUN git clone https://github.com/ded3t/simple-torrent.git .
ENV GO111MODULE=on CGO_ENABLED=0
RUN go build -ldflags "-s -w -X main.VERSION=$(git describe --abbrev=0 --tags)" -o /usr/local/bin/cloud-torrent
############################
# STEP 2 build a small image
############################
FROM alpine
COPY --from=builder /usr/local/bin/cloud-torrent /usr/local/bin/cloud-torrent
ENTRYPOINT ["cloud-torrent"]
