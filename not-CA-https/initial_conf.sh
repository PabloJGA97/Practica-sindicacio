#!/bin/bash

# carpetes de configuracio i certificats
mkdir ./{config,certs}

# certificat
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -keyout ./certs/privkey.key \
    -out ./certs/server.crt \
    -subj '/C=SP/ST=Testing/L=Barcelona/O=ITIC/CN=localhost' \
    -addext "basicConstraints=critical,CA:FALSE" \
    -addext "keyUsage=digitalSignature,keyEncipherment" \
    -addext "extendedKeyUsage=serverAuth"

chmod 600 certs/privkey.key
chmod 644 certs/server.crt

tee ./config/https.conf << EOF
<VirtualHost *:443>
    ServerName localhost
    DocumentRoot /var/www/html
    
    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/server.crt
    SSLCertificateKeyFile /etc/apache2/ssl/privkey.key
    
    Protocols h2 http/1.1
    
    <Directory /var/www/html>
        Options +Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF