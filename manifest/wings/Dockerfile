FROM golang:1.16-alpine as build

ARG VERSION

RUN \
    apk add git \
    && cd / \ 
    && git clone -b gameinfo https://github.com/Shigbeard/pterodactyl-wings --depth 1 \
    && cd pterodactyl-wings \
    && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
        -ldflags="-s -w -X github.com/pterodactyl/wings/system.Version=$VERSION" \
        -v \
        -trimpath \
        -o wings \
        wings.go

FROM alpine:latest as final

LABEL maintainer="Phoenix"

RUN \
    apk add --no-cache ca-certificates tini tzdata \
    && mkdir -p /etc/pterodactyl /var/log/pterodactyl /tmp/pterodactyl 

# Copy wings from build stage
COPY --from=build /pterodactyl-wings/wings /usr/local/bin

COPY ./root /
RUN chmod 755 /entrypoint.sh

EXPOSE 8080
EXPOSE 2022

RUN addgroup -g 3000 pterodactyl \
    && adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "pterodactyl" \
    --no-create-home \
    --uid "3000" \
    "pterodactyl" 

# Default Work Directory
WORKDIR /var/lib/pterodactyl

ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]
