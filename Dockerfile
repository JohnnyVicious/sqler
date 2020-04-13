FROM golang:alpine

WORKDIR /app

RUN apk add --no-cache git gcc musl-dev

RUN CGO_ENABLED=1 go get --tags "linux sqlite_stat4 sqlite_allow_uri_authority sqlite_fts5 sqlite_introspect sqlite_json" github.com/alash3al/sqler

ENV DSN="sqlserver://sqler:gMI7Lf0z8mFYd1SV8vboA834d@mssql"
ENV RESP=:3678
ENV CONFIG=config.*.hcl
ENV REST=:8025
ENV DRIVER=sqlserver
ENV WORKERS=4
COPY config.*.hcl /app/

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8025
ENV PATH=$PATH:/usr/local/bin

WORKDIR /app

ENTRYPOINT ["./entrypoint.sh"]
