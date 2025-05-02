sudo chown ubuntu:ubuntu chirpstack-client.key

# Set read-only permissions for the owner only (400)
sudo chmod 400 chirpstack-client.key


cfssl gencert \
  -ca ../certs/ca.pem \
  -ca-key ../certs/ca-key.pem \
  -config ca-config.json \
  -profile client \  # Note: Using 'client' profile, not 'server'
  chirpstack-client.json | cfssljson -bare chirpstack-client



cfssl gencert -ca ../certs/ca.pem -ca-key ../certs/ca-key.pem -c
onfig ca-config.json -profile client chirpstack-client.json | cfssljson -bare chirpstack-client