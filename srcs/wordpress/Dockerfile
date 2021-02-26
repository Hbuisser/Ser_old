FROM alpine

MAINTAINER Henry Buisseret <hbuisser@student.s19.be>

# Download :
RUN	apk add wget php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session 
RUN apk add nginx && \
	wget http://fr.wordpress.org/latest-fr_FR.tar.gz -P /tmp && \
	tar xzf /tmp/latest-fr_FR.tar.gz

