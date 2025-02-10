#!/bin/bash

# carpetes de configuracio i certificats
mkdir ./config 

# config
tee ./config/http.conf << EOF
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/html
    #Protocols h2c http/1.1
    Protocols h2c 
    
    <Directory /var/www/html/http>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF