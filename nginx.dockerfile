FROM nginx
ADD https://raw.githubusercontent.com/kmein/menstruation-web/master/index.html /usr/share/nginx/html/
RUN chmod 400 /usr/share/nginx/html/index.html \
    && chown nginx /usr/share/nginx/html/index.html