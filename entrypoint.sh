#!/bin/sh
ls -l

FILE=./sqler
if [ -f "$FILE" ]; then
    echo "$FILE exist, removing folder"
    rm -rf ./sqler
fi

git clone https://github.com/JohnnyVicious/sqler.git

cp -f ./sqler/config.*.hcl /app/

ls -l

sqler -driver=${DRIVER} -rest=${REST} -dsn=${DSN} -config=${CONFIG} -workers=${WORKERS} -resp=${RESP}
