FROM golang:alpine

RUN apk add --no-cache git gcc musl-dev

RUN CGO_ENABLED=1 go get --tags "linux sqlite_stat4 sqlite_allow_uri_authority sqlite_fts5 sqlite_introspect sqlite_json" github.com/alash3al/sqler

ENV DRIVER=mssql
ENV USER=youruser
ENV PASS=yourpassword
ENV DBHOST=mssql
ENV DBPORT=1433
ENV DBNAME=yourdbname

#ENTRYPOINT ["sqler -driver=$DRIVER -dsn=$USER:$PASS@tcp($DBHOST:$DBPORT)/$DBNAME"]

EXPOSE 8025:8025
CMD [ "sh", "-c", "sh startup sqler -driver=$DRIVER -dsn=$USER:$PASS@tcp($DBHOST:$DBPORT)" ]

WORKDIR /root/
