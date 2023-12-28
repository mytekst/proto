FROM ubuntu:latest

RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:longsleep/golang-backports
RUN apt install -y wget nodejs npm golang protobuf-compiler

# Install gRPC-Web generator
RUN npm install -g protoc-gen-grpc-web

# Add certificate to install protoc-gen-go
# https://stackoverflow.com/questions/68333944/docker-go-image-cannot-go-get-x509-certificate-signed-by-unknown-authority
RUN wget http://www.cisco.com/security/pki/certs/ciscoumbrellaroot.cer
RUN openssl x509 -inform DER -in ciscoumbrellaroot.cer -out ciscoumbrellaroot.crt
RUN cp ciscoumbrellaroot.crt /usr/local/share/ca-certificates/ciscoumbrellaroot.crt
RUN update-ca-certificates

# Install Golang generators
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31 && mv "$(go env GOPATH)/bin/protoc-gen-go" /usr/bin/protoc-gen-go && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3 && mv "$(go env GOPATH)/bin/protoc-gen-go-grpc" /usr/bin/protoc-gen-go-grpc
