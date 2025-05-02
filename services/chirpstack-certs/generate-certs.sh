#!/bin/bash
# ---------------------------------------------------------------
# ChirpStack Certificate Generator (No Host Validation)
# Author: Carlos Alejandro Perez Garcia <cpgarcia518@gmail.com>
# Organization: iot_org
# Location: Bologna, Italy
# Version: 1.0
# ---------------------------------------------------------------
# Usage: ./generate-certs.sh [PROFILE]
# Example: ./generate-certs.sh server
# ---------------------------------------------------------------

set -euo pipefail

# ==================== CONFIGURATION ====================
CERT_DIR="./config"
OUTPUT_DIR="./certs"
CA_PREFIX="ca"
PROFILE="${1:-}"
CERT_PREFIX="mqtt-${1:-}"


[ -z "$PROFILE" ] && echo "❌ Error: Missing profile" && exit 1

# ==================== GENERATION FUNCTIONS ====================
generate_ca() {
  [ -f "$OUTPUT_DIR/$CA_PREFIX.pem" ] || {
    cfssl gencert -initca "$CERT_DIR/ca-csr.json" | cfssljson -bare "$OUTPUT_DIR/$CA_PREFIX"
    echo "✅ Root CA Generated"
  }
}

generate_cert() {
  [ -f "$OUTPUT_DIR/$CERT_PREFIX.pem" ] || {
    cfssl gencert \
      -ca "$OUTPUT_DIR/$CA_PREFIX.pem" \
      -ca-key "$OUTPUT_DIR/$CA_PREFIX-key.pem" \
      -config "$CERT_DIR/ca-config.json" \
      -profile "$PROFILE" \
      "$CERT_DIR/$CERT_PREFIX.json" | cfssljson -bare "$OUTPUT_DIR/$CERT_PREFIX"
    echo "✅ MQTT Certificate Generated"
  }
}

# ==================== MAIN EXECUTION ====================
mkdir -p "$OUTPUT_DIR"
generate_ca
generate_cert

# Set secure permissions
chmod 600 "$OUTPUT_DIR"/*-key.pem
chmod 644 "$OUTPUT_DIR"/*.pem

echo "🔐 Certificates ready in $OUTPUT_DIR:"
ls -l "$OUTPUT_DIR"/*.pem

