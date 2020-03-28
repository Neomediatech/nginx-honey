#!/bin/bash

LOGDIR="/logs"
LOGFILE="$LOGDIR/access.log"

if [ ! -d "${LOGDIR}" ]; then
    mkdir -p "${LOGDIR}"
    chown www-data "${LOGDIR}"
fi

if [ ! -f "${LOGFILE}" ]; then
    touch "${LOGFILE}"
    chown www-data "${LOGFILE}"
fi

if [ -f /etc/nginx/sites-enabled/default ]; then
  cat <<EOF > /etc/nginx/sites-enabled/default
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF
fi

# Check custom configuration files
SRC_DIR="/data"
DST_DIR="/etc/nginx/sites-enabled"
if [ -d "${SRC_DIR}" ]; then
  cd "${SRC_DIR}"
  for FILE in $(find . -type f|cut -b 3-); do
    DIR_FILE="$(dirname "$FILE")"
    if [ ! -d "$DST_DIR/$DIR_FILE" ]; then
      mkdir -p "$DST_DIR/$DIR_FILE"
    fi
    if [ -f "$DST_DIR/$FILE}" ]; then
      echo "  WARNING: $DST_DIR/$FILE already exists and will be overriden"
      rm -f "$DST_DIR/$FILE"
    fi
    echo "  Add custom config file $DST_DIR/$FILE ..."
    ln -sf "$SRC_DIR/$FILE" "$DST_DIR/$FILE"
  done
fi

# Check custom snippets
SRC_DIR="/snippets"
DST_DIR="/etc/nginx/snippets"
if [ -d "${SRC_DIR}" ]; then
  cd "${SRC_DIR}"
  for FILE in $(find . -type f|cut -b 3-); do
    DIR_FILE="$(dirname "$FILE")"
    if [ ! -d "$DST_DIR/$DIR_FILE" ]; then
      mkdir -p "$DST_DIR/$DIR_FILE"
    fi
    if [ -f "$DST_DIR/$FILE}" ]; then
      echo "  WARNING: $DST_DIR/$FILE already exists and will be overriden"
      rm -f "$DST_DIR/$FILE"
    fi
    echo "  Add custom config file $DST_DIR/$FILE ..."
    ln -sf "$SRC_DIR/$FILE" "$DST_DIR/$FILE"
  done
fi

exec tail -F ${LOGFILE} &
exec "$@"
