#!/bin/bash
# ---------------------------------------------------------------
# ChirpStack Certificate Generator (No Host Validation)
# Author: Carlos Alejandro Perez Garcia <cpgarcia518@gmail.com>
# Organization: iot_org
# Location: Bologna, Italy
# Version: 1.0
# ---------------------------------------------------------------
# Usage: ./generate-certs.sh [GATEWAY_ID]
# Example: ./generate-certs.sh 08
# ---------------------------------------------------------------

set -euo pipefail

# ==================== CONFIGURATION ====================
CERT_DIR="./config"
OUTPUT_DIR="./certs"
CA_PREFIX="ca"
SERVER_PREFIX="mqtt-server"
GATEWAY_ID="${1:-}"

[ -z "$GATEWAY_ID" ] && echo "❌ Error: Missing gateway ID" && exit 1

# ==================== CERTIFICATE TEMPLATES ====================
generate_gateway_config() {
  local gw_id=$1
  cat > "$CERT_DIR/$gw_id.json" <<EOF
{
  "CN": "$gw_id.iot_org.local",
  "key": { 
    "algo": "rsa",
    "size": 4096 
  },
  "names": [{
    "C": "IT",
    "ST": "Emilia-Romagna",
    "L": "Bologna",
    "O": "iot_org",
    "OU": "LoRaWAN Gateway"
  }]
}
EOF
}

# ==================== GENERATION FUNCTIONS ====================
generate_ca() {
  [ -f "$OUTPUT_DIR/$CA_PREFIX.pem" ] || {
    cfssl gencert -initca "$CERT_DIR/ca-csr.json" | cfssljson -bare "$OUTPUT_DIR/$CA_PREFIX"
    echo "✅ Root CA Generated"
  }
}

generate_server_cert() {
  [ -f "$OUTPUT_DIR/$SERVER_PREFIX.pem" ] || {
    cfssl gencert \
      -ca "$OUTPUT_DIR/$CA_PREFIX.pem" \
      -ca-key "$OUTPUT_DIR/$CA_PREFIX-key.pem" \
      -config "$CERT_DIR/ca-config.json" \
      -profile server \
      "$CERT_DIR/mqtt-server.json" | cfssljson -bare "$OUTPUT_DIR/$SERVER_PREFIX"
    echo "✅ MQTT Server Certificate Generated"
  }
}

generate_gateway_cert() {
  local gw_id="gateway$1"
  generate_gateway_config "$gw_id"
  
  cfssl gencert \
    -ca "$OUTPUT_DIR/$CA_PREFIX.pem" \
    -ca-key "$OUTPUT_DIR/$CA_PREFIX-key.pem" \
    -config "$CERT_DIR/ca-config.json" \
    -profile client \
    "$CERT_DIR/$gw_id.json" | cfssljson -bare "$OUTPUT_DIR/$gw_id"
  
  rm "$CERT_DIR/$gw_id.json"
  echo "✅ Gateway Certificate for $gw_id Generated"
}

# ==================== MAIN EXECUTION ====================
mkdir -p "$OUTPUT_DIR"
generate_ca
generate_server_cert
generate_gateway_cert "$GATEWAY_ID"

# Set secure permissions
chmod 600 "$OUTPUT_DIR"/*-key.pem
chmod 644 "$OUTPUT_DIR"/*.pem

echo "🔐 Certificates ready in $OUTPUT_DIR:"
ls -l "$OUTPUT_DIR"/{ca.pem,mqtt-server.pem,"gateway$GATEWAY_ID".pem}