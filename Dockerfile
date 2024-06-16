# Use a base image that has Docker installed, since we're focusing on running VECTR inside a Docker container
FROM docker:20.10.12

# Install necessary dependencies for VECTR
RUN apk --no-cache add \
    ca-certificates \
    curl \
    wget \
    unzip \
    nano \
    && rm -rf /var/cache/apk/*

# Create directories and download VECTR Runtime
WORKDIR /opt/vectr
RUN mkdir -p /opt/vectr \
    && wget https://github.com/SecurityRiskAdvisors/VECTR/releases/download/ce-9.0.2/sra-vectr-runtime-9.0.2-ce.zip \
    && unzip sra-vectr-runtime-9.0.2-ce.zip \
    && rm sra-vectr-runtime-9.0.2-ce.zip

# Copy .env file to set up configuration
COPY .env /opt/vectr/.env

# Expose the required ports (adjust as per your application)
EXPOSE 8081

# Command to start VECTR (example using docker-compose)
CMD ["docker-compose", "up", "-d"]

# Provide instructions for accessing the web app and default credentials
# Replace with actual instructions once the container is running
