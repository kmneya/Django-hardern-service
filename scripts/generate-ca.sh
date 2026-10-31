#!/usr/bin/env bash
# Creates a Root Certificate Authority.
# The CA private key is the most sensitive file in this whole project —
# whoever holds it can issue certs that your server will trust.

set -euo pipefail   # fail fast on any error

CERT_DIR="$(dirname "$0")/../certs/ca"
mkdir -p "$CERT_DIR"
cd "$CERT_DIR"

# 1. Generate the CA private key (RSA 4096, encrypted with a passphrase)
openssl genrsa \
    -aes256 \
    -out ca.key \
    4096

# 2. Self-sign the CA certificate (valid 10 years)
openssl req -x509 \
    -new \
    -key ca.key \
    -sha256 \
    -days 3650 \
    -out ca.crt \
    -subj "/C=HU/ST=Budapest/L=Budapest/O=StudentLab/OU=Cybersecurity/CN=StudentLab Root CA"