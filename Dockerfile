# Use a base image suitable for your application
FROM ${VECTR_IMAGE}

# Expose port 8081 for the application
EXPOSE 8081

# Set environment variables
ENV VECTR_HOSTNAME=${VECTR_HOSTNAME} \
    VECTR_PORT=${VECTR_PORT} \
    POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    POSTGRES_USER=${POSTGRES_USER} \
    POSTGRES_DB=${POSTGRES_DB} \
    VECTR_DATA_KEY=${VECTR_DATA_KEY} \
    JWS_KEY=${JWS_KEY} \
    JWE_KEY=${JWE_KEY} \
    VECTR_EXTERNAL_HOSTNAME=${VECTR_EXTERNAL_HOSTNAME} \
    VECTR_EXTERNAL_PORT=${VECTR_EXTERNAL_PORT} \
    CA_PASS=${CA_PASS} \
    VECTR_FEATURES_SSLCONF=${VECTR_FEATURES_SSLCONF} \
    VECTR_SSL_CRT=${VECTR_SSL_CRT} \
    VECTR_SSL_KEY=${VECTR_SSL_KEY} \
    RESET_SSL=${RESET_SSL} \
    RATE_LIMIT_MAX_REQUESTS=${RATE_LIMIT_MAX_REQUESTS}

# Optionally, you can add a volume mount here if necessary
# VOLUME ${VECTR_SSL_CERTS_VOLUME}

# Start command (adjust this based on how your application is started)
CMD ["your_application_start_command"]
