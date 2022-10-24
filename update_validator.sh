#!/bin/bash

EC2_PUBLIC_IP=$1

# Update systemd service
cd /etc/systemd/system
echo "
	[Unit]
	Description=SX Node Service
  After=network.target
	[Service]
	Type=simple
	Restart=always
	RestartSec=1
	User=$USER
	LimitNOFILE=100000
	WorkingDirectory=/home/$USER/validator
	ExecStart=/home/$USER/validator/sx-node/main server --config config.yml
	[Install]
	WantedBy=multi-user.target
" | sudo tee sx-node.service
sudo systemctl daemon-reload

# Update config
cd /home/$USER/validator/sx-node
echo "
chain_config: /home/$USER/validator/sx-node/genesis.json
data_dir: /home/$USER/validator/sx-node/data
block_gas_target: 0x3938700
grpc_addr: 0.0.0.0:10000
jsonrpc_addr: 0.0.0.0:10002
network:
  libp2p_addr: 0.0.0.0:10001
  nat_addr: $EC2_PUBLIC_IP
seal: true
tx_pool:
  price_limit: 1000000000
log_level: DEBUG
gasprice_block_utilization_threshold: 0.95
" | sudo tee config.yml

# Update binary
git pull
sudo systemctl stop sx-node.service
make build
sudo systemctl restart sx-node.service