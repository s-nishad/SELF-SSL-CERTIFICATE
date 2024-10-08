# Step 1: Create a Private Key for the Certificate Authority (CA)
Write-Host "Generating private key for the Certificate Authority..."
openssl genrsa -des3 -out myCA.key 2048
Write-Host "Private key for CA created: myCA.key"

# Step 2: Create a Self-Signed Certificate for the CA
Write-Host "Creating self-signed certificate for CA..."
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 365 -out myCA.pem
Write-Host "Self-signed certificate created: myCA.pem"

# Step 3: Create a Private Key for the HTTPS Certificate
Write-Host "Generating private key for localhost SSL certificate..."
openssl genrsa -out localhost.key 2048
Write-Host "Private key for localhost SSL certificate created: localhost.key"

# Step 4: Create a Certificate Signing Request (CSR)
Write-Host "Generating certificate signing request (CSR) for localhost..."
openssl req -new -key localhost.key -out localhost.csr
Write-Host "CSR created: localhost.csr"

# Step 5: Create a Config File for Subject Alternative Name (SAN)
Write-Host "Creating config file for Subject Alternative Name (SAN)..."
$extContent = @"
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
"@
Set-Content -Path "localhost.ext" -Value $extContent
Write-Host "SAN config file created: localhost.ext"

# Step 6: Sign the Certificate with Your CA
Write-Host "Signing localhost SSL certificate with the CA..."
openssl x509 -req -in localhost.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out localhost.crt -days 365 -sha256 -extfile localhost.ext
Write-Host "Signed SSL certificate created: localhost.crt"

# Step 7: Trust the CA Certificate on Windows
Write-Host "Now, you need to manually trust the CA certificate."
Write-Host "Open Microsoft Management Console (MMC) and import the myCA.pem file into the Trusted Root Certification Authorities."
Write-Host "Process complete. SSL certificate and CA are ready."
