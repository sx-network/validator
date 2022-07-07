
# Become a validator for SX Network

## Running a validator

Interested in helping out to validate blocks on SX Network? Please visit our docs [here](https://docs.sx.technology/developers/become-a-validator) for instructions on how to run your own node and get compensated in SX for your efforts.

## Validator maintenance

Node operators are required to routinely update their validator's version of sx-node, maintain a high uptime (99%), and monitor the health of their instances. This section will evolve over time to include links and how-to guides essential to the duties of a node operator.

### Running your node in safety mode

At times you might be required by an SX Admin to run your node in safety mode. This mode ensures your validator can only sync up to trusted validators. If asked, please follow the steps below:

1. Stop the sx-node service:

    ```
    sudo systemctl stop sx-node
    ```

2. Clear the data-dir within your `sx-node` directory:

    ```
    rm -rf data/blockchain/ data/trie/ data/consensus/snapshots data/consensus/metadata
    ```

3. Add the `--bootnode-only-sync` flag to the sx-node service's systemd file by adding `--bootnode-only-sync` to the end of the line containing `ExecStart=` within `/etc/systemd/system/sx-node.service` and save that file.

    For example your file might look something like:

    ```
    [Unit]
    Description=SX Node Service
    [Service]
    Type=simple
    Restart=always
    RestartSec=1
    RuntimeMaxSec=604800
    User=$USER
    LimitNOFILE=100000
    WorkingDirectory=/home/$USER/validator
    ExecStart=/home/$USER/validator/sx-node/main server --data-dir /home/$USER/validator/sx-node/data --chain /home/$USER/validator/sx-node/genesis.json --grpc-address 0.0.0.0:10000 --libp2p 0.0.0.0:10001 --jsonrpc 0.0.0.0:10002 --nat $EC2_PUBLIC_IP --seal --bootnode-only-sync
    [Install]
    WantedBy=multi-user.target
    ```

4. Restart the sx-node service:

    ```
    sudo systemctl daemon-reload && sudo systemctl restart sx-node
    ```

### Updating to the latest version of sx-node

Coming soon...

### Adding monitoring and alerts to your validator's instance

Coming soon...

### Increasing the volume size on your validator's instance

Coming soon...
