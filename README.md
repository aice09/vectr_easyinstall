# Instructions to Use the Script:
1. Create or update the .env file with the necessary configurations.
2. Save the SSL configuration script to a file, for example, ```vectr_ssl_setup.sh```.
3. Make the script executable:
```bash
chmod +x vectr_ssl_setup.sh
```
4. Run the script:
```bash
./vectr_ssl_setup.sh
```
**Notes:**
- The **.env** file contains all necessary configuration variables.
- The **docker-compose.yml** file reads these variables to configure the VECTR service.
- The **vectr_ssl_setup.sh** script loads the environment variables, ensures Docker and Certbot are installed and running, obtains an SSL certificate from Let's Encrypt, sets up Docker volumes for the SSL certificates, and starts the VECTR Docker containers with SSL enabled.
