FROM alpine:edge as BUILD
EXPOSE 33001 43001
RUN apk add --no-cache netcat-openbsd
ENTRYPOINT [ "nc" ]
