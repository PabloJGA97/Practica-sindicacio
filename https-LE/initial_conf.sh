#!/bin/bash

# carpetes de configuracio i certificats
mkdir ./{config,certs}

# certificat
curl https://traefik.me/privkey.pem -o ./certs/demo.traefik.me.key
curl https://traefik.me/cert.pem -o ./certs/demo.traefik.me.crt

chmod 600 certs/demo.traefik.me.key
chmod 644 certs/demo.traefik.me.crt
sudo chown root:root certs/*

tee ./config/https.conf << EOF
# Put this at the very top of the file, before everything else
ServerName demo.traefik.me

# Global SSL configuration
LoadModule ssl_module modules/mod_ssl.so
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so

SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite HIGH:!aNULL:!MD5
SSLSessionCache "shmcb:/usr/local/apache2/logs/ssl_scache(512000)"

<VirtualHost *:443>
    ServerName demo.traefik.me
    DocumentRoot /var/www/html
    
    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/demo.traefik.me.crt
    SSLCertificateKeyFile /etc/apache2/ssl/demo.traefik.me.key
    
    Protocols h2 http/1.1
    
    <Directory /var/www/html>
        Options +Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF