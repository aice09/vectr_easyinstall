#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found. Please create a .env file with the required configuration."
    exit 1
fi

# Ensure Docker is running
if ! sudo systemctl is-active --quiet docker; then
    echo "Starting Docker service..."
    sudo systemctl start docker
fi

# Install Certbot if not installed
if ! command -v certbot &> /dev/null; then
    echo "Installing Certbot..."
    sudo apt-get update
    sudo apt-get install -y certbot
else
    echo "Certbot is already installed."
fi

# Stop the VECTR Docker containers
echo "Stopping VECTR Docker containers..."
sudo docker-compose down

# Obtain SSL certificate from Let's Encrypt
echo "Obtaining SSL certificate for $DOMAIN..."
sudo certbot certonly --standalone -d $DOMAIN

# Create a Docker volume for SSL certificates if not already created
if ! sudo docker volume ls | grep -q $VECTR_SSL_CERTS_VOLUME; then
    echo "Creating Docker volume for SSL certificates..."
    sudo docker volume create $VECTR_SSL_CERTS_VOLUME
fi

# Copy the SSL certificates to the Docker volume
echo "Copying SSL certificates to Docker volume..."
sudo docker run --rm -v /etc/letsencrypt:/etc/letsencrypt -v $VECTR_SSL_CERTS_VOLUME:/certs alpine cp -r /etc/letsencrypt/live/$DOMAIN /certs

# Update docker-compose.yml for SSL
echo "Updating docker-compose.yml for SSL configuration..."
cat <<EOF > vectr/docker-compose.yml
version: '3'
services:
  vectr:
    image: ${VECTR_IMAGE}
    ports:
      - "${VECTR_EXTERNAL_PORT}:8081"
    volumes:
      - ${VECTR_SSL_CERTS_VOLUME}:/certs:ro
    environment:
      - VECTR_HOSTNAME=${VECTR_HOSTNAME}
      - VECTR_PORT=${VECTR_PORT}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_DB=${POSTGRES_DB}
      - VECTR_DATA_KEY=${VECTR_DATA_KEY}
      - JWS_KEY=${JWS_KEY}
      - JWE_KEY=${JWE_KEY}
      - VECTR_EXTERNAL_HOSTNAME=${VECTR_EXTERNAL_HOSTNAME}
      - VECTR_EXTERNAL_PORT=${VECTR_EXTERNAL_PORT}
      - CA_PASS=${CA_PASS}
      - VECTR_FEATURES_SSLCONF=${VECTR_FEATURES_SSLCONF}
      - VECTR_SSL_CRT=${VECTR_SSL_CRT}
      - VECTR_SSL_KEY=${VECTR_SSL_KEY}
      - RESET_SSL=${RESET_SSL}
      - RATE_LIMIT_MAX_REQUESTS=${RATE_LIMIT_MAX_REQUESTS}
volumes:
  ${VECTR_SSL_CERTS_VOLUME}:
    external: true
EOF

# Start the VECTR Docker containers
echo "Starting VECTR Docker containers with SSL..."
cd vectr
sudo docker-compose up -d

echo "SSL configuration for VECTR is complete. Access it via https://$DOMAIN"
