# Start with a base image of your choice
FROM ubuntu:20.04

# Install necessary tools (if any) and dependencies
RUN apt-get update && \
    apt-get install -y wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Create directory for VECTR installation
WORKDIR /opt/vectr

# Copy the .env file into the Docker image
COPY .env .env

# Define VECTR_RELEASE variable from .env file
ARG VECTR_RELEASE
ENV VECTR_RELEASE=${VECTR_RELEASE}

# Download and extract VECTR
RUN wget https://github.com/SecurityRiskAdvisors/VECTR/releases/download/ce-9.0.2/sra-vectr-runtime-9.0.2-ce.zip && \
    unzip sra-vectr-runtime-9.0.2-ce.zip && \
    rm sra-vectr-runtime-9.0.2-ce.zip

# Set the working directory to the VECTR installation directory
WORKDIR /opt/vectr/sra-vectr-runtime-9.0.2-ce

# Optionally, you may need to configure VECTR or set permissions here
# For example:
# RUN chmod +x start.sh

# Source the .env file to load environment variables
ENV $(cat /opt/vectr/.env | xargs)

# Start command (adjust this based on how your application is started)
CMD ["./start.sh"]
