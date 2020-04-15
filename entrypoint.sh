#!/bin/sh
ls -l

MYFOLDER=./sqler
if [ -d "$MYFOLDER" ]; then
    echo "Folder $MYFOLDER exist, git pull for updates"
    git pull https://github.com/JohnnyVicious/sqler.git
else
    echo "Folder $MYFOLDER does not exist, git clone for the first time"
    git clone https://github.com/JohnnyVicious/sqler.git
fi

cp -f ./sqler/config.*.hcl /app/

ls -l

sqler -driver=${DRIVER} -rest=${REST} -dsn=${DSN} -config=${CONFIG} -workers=${WORKERS} -resp=${RESP}
