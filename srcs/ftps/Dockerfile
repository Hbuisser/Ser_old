FROM alpine

MAINTAINER Henry Buisseret <hbuisser@student.s19.be>

RUN apk update && \
	apk upgrade && \
	apk add --repository http://dl-3.alpinelinux.org/alpine/edge/testing/pure-ftpd && \
	apk add openssl curl

# COPY will transfer local file in your container


#RUN chmod +x entrypoint.sh

# L'instruction EXPOSE permet d'indiquer le port sur lequel votre application écoute
EXPOSE 21
EXPOSE 21000
EXPOSE 21001
EXPOSE 21002
EXPOSE 21003
EXPOSE 21004
EXPOSE 21005