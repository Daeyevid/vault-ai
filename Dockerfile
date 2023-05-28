# Build stage
FROM golang:1.19-bullseye AS go-builder

# Set the working directory
WORKDIR /build
# Set up environment variables
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOPATH=/root/go
ENV DOCKER_BUILDKIT=1
ENV PATH=$PATH:/app/bin:/app/tools/protoc-3.6.1/bin

# Copy files
COPY . .

# Download and build Go dependencies, then compile the binary
RUN go mod download && \
    go build -o bin/vault-web-server ./vault-web-server

# Runtime stage
FROM debian:bookworm-slim

# Copy the compiled vault-web-server binary from the build stage
COPY --from=go-builder /build/bin/vault-web-server /app/bin/vault-web-server

# Copy the app directory
COPY . /app

# Set the working directory
WORKDIR /app

ENV OPENAI_API_KEY="$(cat /app/secret/openai_api_key)"
ENV PINECONE_API_KEY="$(cat /app/secret/pinecone_api_key)"
ENV PINECONE_API_ENDPOINT="$(cat /app/secret/pinecone_api_endpoint)"

# Expose port 8100
EXPOSE 8100

# Execute the vault-web-server binary
CMD ["./bin/vault-web-server"]
