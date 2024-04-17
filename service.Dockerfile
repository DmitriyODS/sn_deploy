FROM golang:1.21.6-alpine3.19 AS HolaBuilder
LABEL stage=HolaBuilder

COPY ${PWD}/hola-back /go/src/back
WORKDIR /go/src/back
RUN go build -mod vendor -v -o ./bin/service.alpine ./cmd

FROM alpine:3.19 AS HolaProd
COPY --from=HolaBuilder /go/src/back/bin/service.alpine /usr/local/bin/hola.alpine
EXPOSE 8080

ENTRYPOINT ["hola.alpine"]