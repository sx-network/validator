# Validator

Validator node for SX Network.

## Instructions

1. Ensure you have an AWS EC2 instance running of instance type t2.medium (minimum) running Ubuntu 20 configured to have an Elastic IP
2. SSH into your instance
3. Run the line below to clone a copy of this repository and start the deploy script:
```
git clone https://github.com/sx-network/validator.git && cd validator && chmod +x start_validator.sh && ./start_validator.sh "$(curl http://checkip.amazonaws.com)" toronto
```

## Viewing logs

To view logs, one can run the follow command:
```
sudo journalctl -u sx-node -f
```

## Documentation
Latest docs are [here](https://docs.sx.technology/).
