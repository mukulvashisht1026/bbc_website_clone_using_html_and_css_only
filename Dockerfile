FROM nginxinc/nginx-unprivileged:stable-alpine
COPY docker.nginx.conf /etc/nginx/conf.d/default.conf
COPY images /usr/share/nginx/html/images/
COPY bbc.html /usr/share/nginx/html/index.html
HEALTHCHECK --interval=30s --timeout=3s CMD wget -q -O /dev/null http://127.0.0.1:8080/ || exit 1
EXPOSE 8080
