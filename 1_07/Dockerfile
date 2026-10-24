FROM ubuntu:24.04

WORKDIR /usr/scr/app

RUN apt-get update
RUN apt-get install -y curl

COPY ./script.sh .

CMD ["./script.sh"]
