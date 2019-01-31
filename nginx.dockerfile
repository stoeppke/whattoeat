FROM nginx
ADD index.html /usr/share/nginx/html/
RUN chmod 400 /usr/share/nginx/html/index.html \
    && chown nginx /usr/share/nginx/html/index.html