# Steps to Create a Local SSL Certificate Authority for Windows

## 1. Create a Private Key for the Certificate Authority (CA)

You need a private key to create a Certificate Authority. This key will be used to sign SSL certificates later.

```bash
openssl genrsa -des3 -out myCA.key 2048
```
* **myCA.key:** This stores your private key.
* **-des3:** Optionally encrypts the private key with a passphrase (you can skip this for local development).

```bash
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 365 -out myCA.pem
```

## 2. Create a Self-Signed Certificate for the CA
Use the private key to create a self-signed certificate for your CA.

```bash
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 365 -out myCA.pem
```
* **myCA.pem:** The CA certificate file.
* **-days 365:** Validity period for the CA (1 year).

## 3. Create a Private Key for the HTTPS Certificate
Generate a private key for the SSL certificate that your local server will use.

```bash
openssl genrsa -out localhost.key 2048
```
* **localhost.key:** Private key for the SSL certificate.

## 4. Create a Certificate Signing Request (CSR)
Generate a CSR, which will be signed by your CA.

```bash
openssl req -new -key localhost.key -out localhost.csr
```
* **localhost.csr:** Certificate Signing Request file.
* **Common Name (CN):** Use localhost to match your local development domain.
* 
## 5. Create a Config File for Subject Alternative Name (SAN)
Create **localhost.ext** to define SANs (Subject Alternative Names) required by modern browsers.

```bash
# localhost.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
```

## 6. Sign the Certificate with Your CA
Sign the **localhost.csr** with your CA to create the SSL certificate.

```bash
openssl x509 -req -in localhost.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out localhost.crt -days 365 -sha256 -extfile localhost.ext
```
* **localhost.crt:** The SSL certificate signed by your CA.

## 7. Trust the CA Certificate (Windows)
To avoid browser warnings, you need to trust the CA certificate.

* Open Microsoft Management Console (MMC).
* Add the Certificates snap-in for the Computer account.
* Import **myCA.pem** under Trusted Root Certification Authorities.

