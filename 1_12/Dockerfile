FROM ubuntu:24.04

RUN apt-get update && apt-get install -y curl ca-certificates
RUN curl -fsSL https://deb.nodesource.com/setup_16.x -o /tmp/node_setup.sh \
    && bash /tmp/node_setup.sh \
    && apt-get install -y nodejs


WORKDIR /src/usr/app

COPY . .

RUN node -v && npm -v
RUN npm install

RUN npm run build

RUN npm install -g serve

EXPOSE 5001

CMD ["serve","-s","-l","5001","build"]
