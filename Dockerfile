FROM nginx:mainline-alpine

RUN apk add openssl
WORKDIR /etc/nginx/keys
RUN openssl genrsa -out default.key 2048
RUN openssl req -new -key "default.key" -subj "/C=US/ST=State/L=City/O=Organization/CN=yourdomain.com" -out "request.csr"
RUN openssl x509 -req -days 365000 -in "request.csr" -signkey "default.key" -out "default.crt"
WORKDIR /root
