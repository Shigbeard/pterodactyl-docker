#!/bin/sh

# Grab versions from txt file
. ./version.txt

# Build panel
DOCKER_BUILDKIT=1 docker build --build-arg VERSION=$PANEL_VERSION -t shigbeard/pterodactyl-panel:$PANEL_VERSION ./panel

# Build Daemon
DOCKER_BUILDKIT=1 docker build --build-arg VERSION=$DAEMON_VERSION -t shigbeard/pterodactyl-daemon:$DAEMON_VERSION ./daemon

# Build Dedicated SFTP Server
# DOCKER_BUILDKIT=1 docker build --build-arg VERSION=$SFTP_VERSION -t shigbeard/pterodactyl-sftp:$SFTP_VERSION ./sftp

