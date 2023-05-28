FROM node:19-slim

ENV GO_VERSION 1.19

RUN apt-get update \
    && apt-get install -y curl \
    && apt-get install -y ca-certificates \
    && curl -SL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -xzC /usr/local \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/go/bin:${PATH}

WORKDIR /app

COPY package*.json ./

# Install a specific version of npm
RUN npm install -g npm@9.6.7

RUN npm install

# Copy the entire application
COPY . .

# Run source-me.sh and go-compile.sh
RUN bash -c 'source ./scripts/source-me.sh && ./scripts/go-compile.sh ./vault-web-server'

CMD ["npm", "start"]
