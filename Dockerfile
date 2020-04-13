FROM golang:alpine

WORKDIR /app

RUN apk add --no-cache git gcc musl-dev

RUN CGO_ENABLED=1 go get --tags "linux sqlite_stat4 sqlite_allow_uri_authority sqlite_fts5 sqlite_introspect sqlite_json" github.com/alash3al/sqler

ENV DRIVER=mssql
ENV DSN=yourdsn

COPY config/config.example.hcl /app/config.example.hcl

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8025
ENV PATH=$PATH:/usr/local/bin

WORKDIR /root/

ENTRYPOINT ["./entrypoint.sh"]
