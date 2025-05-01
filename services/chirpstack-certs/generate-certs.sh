#!/bin/bash
# ---------------------------------------------------------------
# ChirpStack SSL Certificate Generator
# Author: Carlos Alejandro Perez Garcia <cpgarcia518@gmail.com>
# Organization: iot_org
# Location: Bologna, Italy
# Version: 1.0
# ---------------------------------------------------------------

set -e  # Exit on error

# ==================== Configuration ====================
CERT_DIR="./config"
OUTPUT_DIR="./certs"
CA_PREFIX="ca"
SERVER_PREFIX="mqtt-server"

# ==================== Initialize ====================
echo "🔐 ChirpStack Certificate Generation Script"
echo "📅 $(date)"
echo "------------------------------------------------"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# ==================== CA Generation ====================
echo "🛠️  Generating Root CA Certificate..."
cfssl gencert -initca "$CERT_DIR/ca-csr.json" | cfssljson -bare "$OUTPUT_DIR/$CA_PREFIX"

# Verify CA
echo "🔍 CA Certificate Details:"
openssl x509 -in "$OUTPUT_DIR/$CA_PREFIX.pem" -text -noout | grep -E "Issuer:|Subject:|Not Before|Not After"

# ==================== Server Certificate ====================
echo "🖥️  Generating MQTT Server Certificate..."
cfssl gencert \
  -ca "$OUTPUT_DIR/$CA_PREFIX.pem" \
  -ca-key "$OUTPUT_DIR/$CA_PREFIX-key.pem" \
  -config "$CERT_DIR/ca-config.json" \
  -profile server \
  "$CERT_DIR/mqtt-server.json" | cfssljson -bare "$OUTPUT_DIR/$SERVER_PREFIX"

# Verify Server Cert
echo "🔍 Server Certificate Details:"
openssl x509 -in "$OUTPUT_DIR/$SERVER_PREFIX.pem" -text -noout | grep -E "Issuer:|Subject:|DNS:|IP Address:|Not Before|Not After"

# ==================== Set Permissions ====================
echo "🔒 Setting Secure File Permissions..."
chmod 600 "$OUTPUT_DIR"/*-key.pem  # Private keys: RW only by owner
chmod 644 "$OUTPUT_DIR"/*.pem      # Certificates: Readable by all
chmod 644 "$OUTPUT_DIR"/*.csr      # CSR files

# ==================== Final Output ====================
echo "✅ Certificate Generation Complete!"
echo "📁 Output Directory: $OUTPUT_DIR"
ls -lh "$OUTPUT_DIR" | grep -E "\.pem|\.csr"

echo "------------------------------------------------"
echo "💡 Next Steps:"
echo "1. Deploy ca.pem to all clients for trust"
echo "2. Use mqtt-server.pem and mqtt-server-key.pem on your MQTT server"
echo "3. Set TLS config in ChirpStack:"
echo "   - tls_cert = \"$OUTPUT_DIR/$SERVER_PREFIX.pem\""
echo "   - tls_key = \"$OUTPUT_DIR/$SERVER_PREFIX-key.pem\""