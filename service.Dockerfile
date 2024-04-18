FROM golang:1.21.6-alpine3.19 AS SnBuilder
LABEL stage=SnBuilder

COPY ${PWD}/sn_back /go/src/back
WORKDIR /go/src/back
RUN go build -mod vendor -v -o ./bin/service.alpine ./cmd

FROM alpine:3.19 AS SnProd
COPY --from=SnBuilder /go/src/back/bin/service.alpine /usr/local/bin/sn.alpine
EXPOSE 8080

ENTRYPOINT ["sn.alpine"]
