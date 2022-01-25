#!/bin/bash

# STREAM_NAME=node-name = e.g validator-1
STREAM_NAME=$1

echo "Installing vector.."

curl -1sLf \
'https://repositories.timber.io/public/vector/cfg/setup/bash.deb.sh' \
| sudo -E bash

sudo apt-get install vector


# Setup logging:
cd /etc/vector/

echo "
[sources.my_journald_source]
type = \"journald\"

[transforms.my_journald_filter]
type = \"filter\"
inputs = [\"my_journald_source\"]
condition = '''
    (includes([\"sxnode.service\"], ._SYSTEMD_UNIT))
'''

[transforms.my_journald_remap]
type = \"remap\"
inputs = [\"my_journald_filter\"]
source = '''
        e = {}
        e.message = .message
        . = [e]
'''

[sinks.my_cloudwatch_sink]
type = \"aws_cloudwatch_logs\"
inputs = [\"my_journald_remap\"]
compression = \"gzip\"
encoding.codec = \"json\"
region = \"us-east-1\"
group_name = \"SX-Network\"
stream_name = \"$STREAM_NAME\"
create_missing_stream = true
" | sudo tee vector.toml


echo "Restarting vector. Check if CW logs are populating under given stream name"
sudo systemctl restart vector



