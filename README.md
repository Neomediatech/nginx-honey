# nginx-honey
Dockerized Nginx for a HoneyPot project

## vars
- bind mount /logs to keep logfiles
- bind mount /data to use your virtualhost files
- bind mount /snippets to use your own snippets (ssl certificates, partial configurations, etc...)
