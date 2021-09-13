#!/bin/bash

EC2_PUBLIC_IP=$1
NETWORK=$2

FUND_AMOUNT="100000"

echo "Installing dependencies..."
echo
echo

# Install dependencies
wget https://golang.org/dl/go1.16.5.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.16.5.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile

# Clone and build polygons-sdk
git clone https://github.com/sx-network/sx-node.git && cd sx-node  && git checkout $NETWORK
echo "Building Go executable, please wait..."
go build main.go

# Initialize validator dir
echo "Initializing validator directory.."
./main ibft init --data-dir mynode && cp ../genesis.json . && chmod +x genesis.json
echo "Public IP            = $EC2_PUBLIC_IP"
echo
echo
read -n 1 -s -r -p "Please fund the `Public key (address)` above with $FUND_AMOUNT SX and inform an SX Network admin about the 3 fields above. Once this is done, press any key to continue.."
echo
echo

## Show private key
echo
echo
echo
echo "Below is your private key used to access your account. Please make a copy and store this somewhere safe - DO NOT share it with us! Once this is done, press any key to continue.."
echo
echo
echo "----------"
pk=$(cat mynode/consensus/validator.key)
echo "Private Key = $pk"
read -n 1 -s -r -p "----------"

# Create systemd Service File
cd /etc/systemd/system
echo "Starting sx-node service..."
echo "
	[Unit]
	Description=SX Node Service
	[Service]
	Type=simple
	Restart=always
	RestartSec=1
	User=$USER
	Group=$USER
	WorkingDirectory=/home/$USER/sx-toronto-node
	ExecStart=/home/$USER/sx-toronto-node/sx-node/main server --data-dir /home/$USER/sx-toronto-node/sx-node/mynode --chain /home/$USER/sx-toronto-node/sx-node/genesis.json --grpc 0.0.0.0:10000 --libp2p 0.0.0.0:10001 --jsonrpc 0.0.0.0:10002 --nat $EC2_PUBLIC_IP
	[Install]
	WantedBy=multi-user.target
" | sudo tee sx-node.service

if grep -q ForwardToSyslog=yes "/etc/systemd/journald.conf"; then
  sudo sed -i '/#ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
  sudo sed -i '/ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
elif ! grep -q ForwardToSyslog=no "/etc/systemd/journald.conf"; then
  echo "ForwardToSyslog=no" | sudo tee -a /etc/systemd/journald.conf
fi
cd -
echo

# Start systemd Service
sudo systemctl force-reload systemd-journald
sudo systemctl daemon-reload
sudo systemctl start sx-node.service

read -n 1 -s -r -p "Service successfully started! Press any key to continue..."
echo
