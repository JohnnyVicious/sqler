FROM golang:alpine

RUN apk add --no-cache git gcc musl-dev

RUN CGO_ENABLED=1 go get --tags "linux sqlite_stat4 sqlite_allow_uri_authority sqlite_fts5 sqlite_introspect sqlite_json" github.com/alash3al/sqler

ENV DRIVER=mssql
ENV DSN=yourdsn

#ENTRYPOINT ["sqler"]

EXPOSE 8025:8025
CMD [ "sh", "-c", "sh sqler -driver=$DRIVER -dsn=$DSN" ]

WORKDIR /root/
