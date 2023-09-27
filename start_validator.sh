#!/bin/bash

EC2_PUBLIC_IP=$1

# Update systemd service
cd /etc/systemd/system
echo "[Unit]
Description=SX Node Service
After=network.target
[Service]
Type=simple
Restart=always
RestartSec=1
User=$USER
LimitNOFILE=100000
WorkingDirectory=/home/$USER/validator/sx-node
ExecStart=/home/$USER/validator/sx-node/main server --config config.yml
[Install]
WantedBy=multi-user.target" | sudo tee sx-node.service
if grep -q ForwardToSyslog=yes "/etc/systemd/journald.conf"; then
  sudo sed -i '/#ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
  sudo sed -i '/ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
elif ! grep -q ForwardToSyslog=no "/etc/systemd/journald.conf"; then
  echo "ForwardToSyslog=no" | sudo tee -a /etc/systemd/journald.conf
fi
cd -
echo

# Update config
cd /home/$USER/validator/sx-node
echo "chain_config: /home/$USER/validator/sx-node/genesis.json
data_dir: /home/$USER/validator/sx-node/data
block_gas_target: 0x3938700
grpc_addr: 0.0.0.0:10000
jsonrpc_addr: 0.0.0.0:10002
network:
  libp2p_addr: 0.0.0.0:10001
  nat_addr: $EC2_PUBLIC_IP
seal: true
tx_pool:
  price_limit: 20000000000
log_level: DEBUG
gasprice_block_utilization_threshold: 0.95
data_feed:
  verify_outcome_api_url: https://outcome-reporter.sx.technology/api/outcome
  sx_node_address: 0xb2EA86f774CC455bb3BD1Cea73851BF3D2467778
  outcome_reporter_address: 0x041670fF3FfdA1Da64BF54b5aE009eda19BaB8a3
  outcome_voting_period_seconds: 30" | sudo tee config.yml

# Start systemd Service
echo "Starting sx-node service..."
sudo systemctl force-reload systemd-journald
sudo systemctl daemon-reload
sudo systemctl start sx-node.service

read -n 1 -s -r -p "Service successfully started! Press any key to continue..."
echo
