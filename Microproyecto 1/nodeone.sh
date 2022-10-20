#!/bin/bash
echo "Instalando Haproxy"
apt install haproxy -y

echo "Instalando Consul"
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install consul

echo "Instalando Node y NPM"
apt install nodejs -y
apt install npm -y

echo "Configurando Haproxy"
mv /home/vagrant/scripts/haproxy.cfg /etc/haproxy/haproxy.cfg
mv /home/vagrant/scripts/error.http /etc/haproxy/errors/error.http

echo "Configurando Consul"
mv /home/vagrant/scripts/api.json /etc/consul.d/api.json

echo "Configurando proyecto Node JS"
mkdir /server
mv /home/vagrant/scripts/index.js /server/index.js
cd /server
npm i express consul

echo "Reiniciar servicio Haproxy"
cd /
service haproxy reload

echo "Iniciar servidor Consul y Node JS en Port 3000"
echo "$(consul agent -ui -server -bootstrap-expect=1 -node=one -bind=192.168.100.2 -enable-script-checks=true -retry-join "192.168.100.3" -config-dir=/etc/consul.d -data-dir=/tmp/consul -client=0.0.0.0)" & "$(node /server/index.js 3000)"