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

# Download and extract VECTR
RUN wget https://github.com/SecurityRiskAdvisors/VECTR/releases/download/ce-${VECTR_RELEASE}/sra-vectr-runtime-${VECTR_RELEASE}-ce.zip && \
    unzip sra-vectr-runtime-${VECTR_RELEASE}-ce.zip && \
    rm sra-vectr-runtime-${VECTR_RELEASE}-ce.zip

# Set the working directory to the VECTR installation directory
WORKDIR /opt/vectr/sra-vectr-runtime-${VECTR_RELEASE}-ce

# Optionally, you may need to configure VECTR or set permissions here
# For example:
# RUN chmod +x start.sh

# Source the .env file to load environment variables
ENV $(cat /opt/vectr/.env | xargs)

# Start command (adjust this based on how your application is started)
CMD ["./start.sh"]
