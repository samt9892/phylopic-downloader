FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl jq bash coreutils && \
    apt-get clean

# Copy script into container
COPY phylopic_downloader.sh /usr/local/bin/phylopic_downloader.sh

# Make it executable
RUN chmod +x /usr/local/bin/phylopic_downloader.sh

# Set working directory for output
WORKDIR /app
VOLUME /app/downloads

# Run the script by default
CMD ["/usr/local/bin/phylopic_downloader.sh"]