echo "root:hbuisser@" | chpasswd

# Nginx setup
adduser -D -g 'www' www
chown -R www:www /var/lib/nginx
chown -R www:www /www

nginx -g 'pid /tmp/nginx.pid; daemon off;'