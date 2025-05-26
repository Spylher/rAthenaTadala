#!/bin/bash
set -e  # Para o script se algum comando retornar erro

# Cores
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
RESET="\033[0m"

# Ícones
CHECK="${GREEN}✔${RESET}"
STEP="${BLUE}➤${RESET}"

echo -e "${YELLOW}🚀 Iniciando processo de configuração do servidor...${RESET}"
echo ""

echo -e "${STEP} [1/8] Atualizando lista de pacotes..."
sudo apt-get update > /dev/null
echo -e "${CHECK} Lista de pacotes atualizada."
echo ""

echo -e "${STEP} [2/8] Atualizando pacotes instalados..."
sudo apt-get upgrade -y > /dev/null
echo -e "${CHECK} Pacotes atualizados."
echo ""

echo -e "${STEP} [3/8] Instalando pacotes necessários..."
sudo apt-get install -y bsdextrautils make ufw libmysqlclient-dev gcc g++ zlib1g-dev libpcre3-dev > /dev/null
echo -e "${CHECK} Pacotes instalados."
echo ""

echo -e "${STEP} [4/8] Atualizando lista de novos pacotes instalados..."
sudo apt-get update > /dev/null
echo -e "${CHECK} Lista atualizada novamente."
echo ""

echo -e "${STEP} [5/8] Acessando repositório e compilando servidor..."
cd rAthenaTadala
sudo chmod a+x configure
./configure --enable-packetver=20220330 > /dev/null
make clean > /dev/null
make server > /dev/null
echo -e "${CHECK} Servidor compilado com sucesso."
echo ""

echo -e "${STEP} [6/8] Configurando firewall..."
PORTAS=(443 80 20/tcp 21 22 3306 6900 5121 6121 8888)
for porta in "${PORTAS[@]}"; do
    sudo ufw allow "$porta" > /dev/null
done
echo -e "${CHECK} Firewall configurado."
echo ""

echo -e "${STEP} [7/8] Configurando permissões..."
sudo chmod a+x login-server char-server map-server web-server athena-start
echo -e "${CHECK} Permissões ajustadas."
echo ""

echo -e "${STEP} [8/8] Iniciando servidor..."
