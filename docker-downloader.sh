#!/usr/bin/env bash

# Run the PhyloPic downloader script
# This command will:
# --rm Automatically clean up after it exits
# -v Mount ./downloads into the container
# -w Set the working directory (inside container)
# --name Assign a name for easier control


docker run --rm \
  -v "$PWD/downloads:/app/downloads" \
  -w /app \
  --name phylopic-downloader-run \
  ghcr.io/samt9892/phylopic-downloader:latest \
  /usr/local/bin/phylopic-downloader.sh