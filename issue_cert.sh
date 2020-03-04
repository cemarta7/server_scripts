#!/bin/bash

certroot="/etc/ssl/private"
acme=/root/.acme.sh/acme.sh

if [ -z "$1" ]; then
        echo "usage: $0 <domain>"
        exit 1
fi

domain="$1"

ip="`dig +short $domain`"

echo "[+] $domain resolves to: $ip"

if [ -z "$ip" ]; then
        echo "$domain doesn't resolve to anything!"
        exit 1
fi

echo -n "are you sure you want to issue a cert for this domain? [Y/n]"
read -n 1 input
echo

if [ $(echo "${input,,}") == "y" ]; then
        echo "[+] generating certs with acme... "
        mkdir "$certroot/$domain"
        #$acme --issue --standalone -d "$domain" && \
        $acme --issue --standalone -d "$domain" && \
        $acme --installcert -d "$domain" --fullchainpath "$certroot/$domain/cert.pem" --keypath "$certroot/$domain/cert.key" || rmdir "$certroot/$domain"
else
        echo "Never mind, then."
        mv /tmp/https-redirect /etc/nginx/sites-enabled/https-redirect
fi
