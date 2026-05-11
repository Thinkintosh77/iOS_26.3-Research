#!/bin/bash
# Overlord Workspace Setup - Certificate & Signage Automation

mkdir -p certs keys payloads
echo "[*] Generating Local CA..."

# 1. Create Root CA
openssl ecparam -name prime256v1 -genkey -noout -out keys/MyPrivateCA.key
openssl req -x509 -new -nodes -key keys/MyPrivateCA.key -sha256 -days 3650 -out certs/MyPrivateCA.pem \
-subj "/C=US/ST=CA/O=Apple Inc./CN=Apple Root CA"

# 2. Create Albert Spoof Cert (for mitmproxy/flask)
openssl ecparam -name prime256v1 -genkey -noout -out keys/albert_spoof.key
openssl req -new -key keys/albert_spoof.key -out certs/albert_spoof.csr \
-subj "/C=US/ST=CA/O=Apple Inc./CN=albert.apple.com"
openssl x509 -req -in certs/albert_spoof.csr -CA certs/MyPrivateCA.pem -CAkey keys/MyPrivateCA.key \
-CAcreateserial -out certs/albert_spoof.pem -days 365 -sha256

echo "[+] Workspace Ready. Place your 'fdr_local.key' in the /keys folder."


## Coded by Thinkintosh77, Public use no rebranding
## May/12/2026-2:42AM

