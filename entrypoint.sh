#!/bin/sh
ls -l

MYFOLDER=./sqler
if [ -d "$MYFOLDER" ]; then
    echo "Folder $MYFOLDER exist, removing folder"
    rm -rf ./sqler
fi

git clone https://github.com/JohnnyVicious/sqler.git

cp -f ./sqler/config.*.hcl /app/

ls -l

sqler -driver=${DRIVER} -rest=${REST} -dsn=${DSN} -config=${CONFIG} -workers=${WORKERS} -resp=${RESP}