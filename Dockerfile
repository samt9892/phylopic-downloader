FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        curl \
        jq \
        bash \
        coreutils \
        librsvg2-bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Copy script into container
COPY phylopic-downloader.sh /usr/local/bin/phylopic-downloader.sh
COPY phylopic-converter.sh /usr/local/bin/phylopic-converter.sh

# Make them executable
RUN chmod +x /usr/local/bin/phylopic-downloader.sh \
    && chmod +x /usr/local/bin/phylopic-converter.sh

# Set working directory for output
WORKDIR /app
VOLUME /app/downloads

# Run the script by default
CMD ["bash"]