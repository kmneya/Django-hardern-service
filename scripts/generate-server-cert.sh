#!/usr/bin/env bash
# Creates the server key + CSR, then signs the CSR with our Root CA.
# This is the standard CA workflow: the server never sees the CA key.

set -euo pipefail

ROOT="$(dirname "$0")/.."
CA_DIR="$ROOT/certs/ca"
SRV_DIR="$ROOT/certs/server"
mkdir -p "$SRV_DIR"

# 1. Server private key (NOT encrypted — Nginx needs to read it unattended)
openssl genrsa -out "$SRV_DIR/server.key" 2048

# 2. Certificate Signing Request
openssl req -new \
    -key "$SRV_DIR/server.key" \
    -out "$SRV_DIR/server.csr" \
    -subj "/C=HU/ST=Budapest/L=Budapest/O=StudentLab/OU=Cybersecurity/CN=localhost"

# 3. Sign the CSR with our CA (this is the step that makes it "our own CA")
openssl x509 -req \
    -in "$SRV_DIR/server.csr" \
    -CA "$CA_DIR/ca.crt" \
    -CAkey "$CA_DIR/ca.key" \
    -CAcreateserial \
    -out "$SRV_DIR/server.crt" \
    -days 365 \
    -sha256 \
    -extfile <(printf "subjectAltName=DNS:localhost,IP:127.0.0.1")