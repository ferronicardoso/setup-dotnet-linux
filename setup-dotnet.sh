#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

clear

printf "\n"
printf "${GREEN}# Update system ###################################################################################### ${NC}\n"

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y autoclean

printf "\n"
printf "${GREEN}# Setup Tools #######################################################################################${NC}\n"

sudo apt-get install jq wget curl -y
wget -O dotnet-install.sh https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh
sudo chmod 700 dotnet-install.sh

printf "\n"
printf "${GREEN}# Setup SDK #########################################################################################${NC}\n"

curl -s https://raw.githubusercontent.com/dotnet/core/main/release-notes/releases-index.json | 
jq --raw-output '."releases-index" | .[:4] | map({ version: ."latest-sdk" }) | .[] | .version' | 

while read version; do
    printf "Version: ${RED}$version${NC}\n"
    ./dotnet-install.sh --version $version
done

echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >> ~/.bashrc
source ~/.bashrc

printf "\n"
printf "${GREEN}# DOTNET CLI Version ################################################################################${NC}\n"
printf "${RED}"
dotnet --version
printf "${NC}"

printf "\n"
printf "${GREEN}# Enviranment variables #############################################################################${NC}\n"

echo $PATH

printf "\n"
printf "${GREEN}# SDKs ##############################################################################################${NC}\n"

dotnet --list-sdks

printf "\n"
printf "${GREEN}# Runtimes ##########################################################################################${NC}\n"

dotnet --list-runtimes

printf "\n"
printf "${GREEN}### Finish! ### ${NC}\n"
printf "\n"