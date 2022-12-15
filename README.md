
# Become a validator for SX Network

## Running a validator

Interested in helping out to validate blocks on SX Network? Please visit our docs [here](https://docs.sx.technology/developers/become-a-validator) for instructions on how to run your own node and get compensated in SX for your efforts.

## Validator maintenance

Node operators are required to routinely update their validator's version of sx-node, maintain a high uptime (99%), and monitor the health of their instances. This section will evolve over time to include links and how-to guides essential to the duties of a node operator.

### Updating to the latest version of sx-node

From within your `validator` directory: 
```
git pull && chmod +x update_validator.sh && ./update_validator.sh "$(curl http://checkip.amazonaws.com)"
```
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

3. Add the `bootnode_only_sync: true` field to the `config.yml` and save that file.

    For example your `config.yml` file might look something like:

    ```
    chain_config: /home/heisenberg/validator/sx-node/genesis.json
    data_dir: /home/heisenberg/validator/sx-node/data
    block_gas_target: 0x3938700
    grpc_addr: 0.0.0.0:10000
    jsonrpc_addr: 0.0.0.0:10002
    network:
      libp2p_addr: 0.0.0.0:10001
      nat_addr: 127.0.0.1
    seal: true
    tx_pool:
      price_limit: 1000000000
    log_level: DEBUG
    gasprice_block_utilization_threshold: 0.95
    data_feed:
      verify_outcome_api_url: https://outcome-reporter.sx.technology/api/outcome
    ```

4. Restart the sx-node service:

    ```
    sudo systemctl daemon-reload && sudo systemctl restart sx-node
    ```

### Adding monitoring and alerts to your validator's instance

Coming soon...

### Increasing the volume size on your validator's instance

Coming soon...

### Sync from a backup archive

Coming soon...
