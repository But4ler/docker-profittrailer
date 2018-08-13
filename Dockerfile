FROM alpine:3.7

ARG PTD_VERSION=${PTD_VERSION:-1.11.1}
ENV PTD_VERSION ${PTD_VERSION}

RUN apk add --no-cache curl
RUN curl -SL curl https://github.com/PTDefender/Welcome/archive/1.11.1.tar.gz | tar -zxvf /opt/ptdefender

VOLUME ["/opt/ptdefender"]