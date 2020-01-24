FROM neomediatech/ubuntu-base:latest

ENV VERSION=from-ubuntu \
    SERVICE=nginx-honey

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/${SERVICE} \
      org.label-schema.maintainer=Neomediatech

RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends nginx-extras && \
    rm -rf /var/lib/apt/lists* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY bin/* /
RUN chmod +x /entrypoint.sh 

EXPOSE 80

# ToDO: more useful check
# HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=20 CMD nc -w 7 -zv 0.0.0.0 80
      
ENTRYPOINT ["/entrypoint.sh"]
STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
