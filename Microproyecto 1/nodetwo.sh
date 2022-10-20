echo "Instalando Consul"
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install consul

echo "Instalando Node y NPM"
apt install nodejs -y
apt install npm -y

echo "Configurando Consul"
mv /home/vagrant/scripts/api.json /etc/consul.d/api.json

echo "Configurando proyecto Node JS"
mkdir /server
mv /home/vagrant/scripts/index.js /server/index.js
cd /server
npm i express consul

echo "Iniciar servidor Consul y Node JS serve en Port 3001 y 3003"
echo "$(consul agent -data-dir=/tmp/consul -node=two -bind=192.168.100.3 -enable-script-checks=true -config-dir=/etc/consul.d -client=0.0.0.0)" & "$(node /server/index.js 3001)" & "$(node /server/index.js 3003)"