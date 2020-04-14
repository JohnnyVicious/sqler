#!/bin/sh
ls

sqler -driver=${DRIVER} -rest=${REST} -dsn=${DSN} -config=${CONFIG} -workers=${WORKERS} -resp=${RESP}
