FROM golang:1.27.3

WORKDIR /usr/src/app
COPY . .

RUN go build -o server
RUN go test ./...

EXPOSE 8080

CMD ["./server"]
