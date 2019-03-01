FROM alpine

RUN apk add --update --no-cache dhcp dumb-init && rm -rf /var/cache/apk/*
#RUN apk add --update --no-cache perl

COPY util/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
