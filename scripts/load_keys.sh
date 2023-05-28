#!/bin/sh

export OPENAI_API_KEY=$(cat /app/secret/openai_api_key)
export PINECONE_API_KEY=$(cat /app/secret/pinecone_api_key)
export PINECONE_API_ENDPOINT=$(cat /app/secret/pinecone_api_endpoint)

echo "=> API Keys Loaded"
