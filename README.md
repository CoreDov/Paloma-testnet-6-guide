# Paloma-testnet-5 node instalation guide
### Hardware requirements:

CPU	4 theads

RAM	8GB

Storage	SSD 200GB

Bandwidth: 1 Gbps for Download/100 Mbps for Upload

## Preparing ot instalation:
### update all packages:
```shell
sudo apt update && sudo apt upgrade -y
apt install jq -y
```
### set up all variables
```shell
# Variables that you need to change for yourself
MONIKER=Paste_here_your_moniker_name
WALLET=Paste_here_your_wallet_name
WEBSITE=(Paste here website that will be displayed on the validator page in the explorer(optional))
IDENTITY=(Paste here your 16-digit code from keybase.io for setting avatar of your validator(optional))
# Variables that cannot be changed
TIKER=palomad
CHAIN=paloma-testnet-5
TOKEN=ugrain
PROJECT=palomad
CONFIG=.paloma
NODE=http://localhost:26657
GENESIS_JSON_PATH=https://raw.githubusercontent.com/palomachain/testnet/master/paloma-testnet-5/genesis.json
```
