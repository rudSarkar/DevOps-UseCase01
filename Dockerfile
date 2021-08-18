FROM node:latest

LABEL maintainer "hello@rudra0x01.xyz"

RUN mkdir -p /app

WORKDIR /app

COPY package.json /app/package.json

COPY *.js /app/

RUN npm install express

HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:3000 || exit 1

CMD ["node","main.js"]
EXPOSE 3000
