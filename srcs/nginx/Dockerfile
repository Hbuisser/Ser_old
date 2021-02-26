FROM alpine

# Set workdir
RUN		mkdir /tmp/ft_services_payload /www
ADD		srcs/ /tmp/ft_services_payload
WORKDIR	/tmp/ft_services_payload

# Install core services
RUN		apk add nginx 

# Moving necessary files
ADD		srcs/nginx.conf /etc/nginx/
ADD		www/index.html /www

# Test
# COPY    srcs/server.crt /etc/ssl/certs/server.crt
# COPY    srcs/server.key /etc/ssl/private/server.key

EXPOSE	80 443

CMD [ "/bin/ash", "/tmp/ft_services_payload/init.sh" ]