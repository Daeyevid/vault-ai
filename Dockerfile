FROM node:19-slim

ENV GO_VERSION 1.19

RUN apt-get update \
    && apt-get install -y curl \
    && curl -SL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -xzC /usr/local \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/go/bin:${PATH}

WORKDIR /app

# Set up environment variables
ENV GO111MODULE=on
ENV GOPATH=/root/go
ENV DOCKER_BUILDKIT=1
ENV PATH=$PATH:/app/bin:/app/tools/protoc-3.6.1/bin

# Load API keys from secret files as environment variables
RUN echo "source /app/scripts/load-keys.sh" >> /etc/profile

COPY package*.json ./

# Install a specific version of npm
RUN npm install -g npm@9.6.7

RUN npm install

# Copy the entire application
COPY . .

# Run source-me.sh and go-compile.sh
RUN bash -c './scripts/go-compile.sh ./vault-web-server'

CMD ["./bin/vault-web-server"]
