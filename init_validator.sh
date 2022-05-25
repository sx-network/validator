#!/bin/bash

EC2_PUBLIC_IP=$1
NETWORK=$2

FUND_AMOUNT="200000"

echo "Installing dependencies..."
echo
echo

# Install dependencies
sudo apt-get update
sudo apt-get -y install build-essential
sudo apt install wget
wget https://golang.org/dl/go1.18.2.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile

# Clone and build polygons-sdk
git clone https://github.com/sx-network/sx-node.git && cd sx-node  && git checkout $NETWORK
echo "Building Go executable, please wait..."
go build main.go

# Initialize validator dir
echo "Initializing validator directory.."
./main secrets init --data-dir data && cp ../genesis.json . && chmod +x genesis.json
echo

## Show private key
pk=$(cat data/consensus/validator.key)
echo "Private Key = $pk"
echo

## Prompt user
echo "Please ensure at least $FUND_AMOUNT SX resides on the \`Public key (address)\` above and inform an SX Network admin about this address as well as your Node ID in the #validators channel on Discord."
echo
echo
read -n 1 -s -r -p "Additionally, please make a copy of your \`Private Key\` and store this somewhere safe - DO NOT share it with us! Once this is done, press any key to continue.."
echo