FROM nginx
ADD file.html /usr/share/nginx/html/
RUN chmod 400 /usr/share/nginx/html/file.html
ADD file.html /usr/share/nginx/html/
RUN chmod 400 /usr/share/nginx/html/file.html \
    && chown nginx /usr/share/nginx/html/file.html