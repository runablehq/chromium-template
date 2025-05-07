#!/bin/bash

set -o pipefail -o errexit

# Set up shared memory properly
mkdir -p /dev/shm
chmod 1777 /dev/shm
sudo mount -t tmpfs -o rw,nosuid,nodev,size=512M tmpfs /dev/shm

# Create log directory for supervisor
mkdir -p /var/log/supervisor

# Set environment variables for Chrome user data dir
if [ -n "$CHROME_USER_DATA_DIR" ]; then
  echo "Using Chrome profile directory: $CHROME_USER_DATA_DIR"
  # Ensure profile directory exists
  mkdir -p "$CHROME_USER_DATA_DIR"
  export CHROME_USER_DATA_DIR="--user-data-dir=$CHROME_USER_DATA_DIR"
else
  # Set to empty string to avoid issues with supervisor
  export CHROME_USER_DATA_DIR=""
fi

# Start all services using supervisord
echo "Starting all services with supervisord..."
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf