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
### set up all variables:
```shell
# Variables that you need to change for yourself
MONIKER=Paste_here_your_moniker_name
WALLET=Paste_here_your_wallet_name
WEBSITE=(Paste here website that will be displayed on the validator page in the explorer(optional))
IDENTITY=(Paste here your 16-digit code from keybase.io for setting avatar of your validator(optional))
# Variables that do not need to be changed
TIKER=palomad
CHAIN=paloma-testnet-5
TOKEN=ugrain
PROJECT=palomad
CONFIG=.paloma
NODE=http://localhost:26657
GENESIS_JSON_PATH=https://raw.githubusercontent.com/palomachain/testnet/master/paloma-testnet-5/genesis.json
```
### Export all var-s:
```shell
echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile
echo "export WALLET=$WALLET" >> $HOME/.bash_profile
echo "export WEBSITE=$WEBSITE" >> $HOME/.bash_profile
echo "export IDENTITY=$IDENTITY" >> $HOME/.bash_profile
echo "export TIKER=$TIKER" >> $HOME/.bash_profile
echo "export CHAIN=$CHAIN" >> $HOME/.bash_profile
echo "export TOKEN=$TOKEN" >> $HOME/.bash_profile
echo "export PROJECT=$PROJECT" >> $HOME/.bash_profile
echo "export CONFIG=$CONFIG" >> $HOME/.bash_profile
echo "export NODE=$NODE" >> $HOME/.bash_profile
echo "export GENESIS_JSON_PATH=$GENESIS_JSON_PATH" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Building and configuring:
### Get binary:
```shell
wget -O - https://github.com/palomachain/paloma/releases/download/v0.2.4-prealpha/paloma_0.2.4-prealpha_Linux_x86_64.tar.gz | \
sudo tar -C /usr/local/bin -xvzf - palomad
sudo chmod +x /usr/local/bin/palomad
# Required until we figure out of cgo
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/raw/main/api/libwasmvm.x86_64.so
```
### Initialization:
```shell
$TIKER init $MONIKER --chain-id $CHAIN
$TIKER config chain-id $CHAIN
$TIKER config keyring-backend test
$TIKER config node $NODE
```
### Creating wallet:
```shell
$TIKER keys add $WALLET
#and save your mnemonic on your pc!!!

#or if you want to recover existing wallet from mnemonic:
$TIKER keys add $WALLET --recover
```
# Downloading genesis and adddrbook:
```shell
cd $HOME/$CONFIG/config
wget -O genesis.json $GENESIS_JSON_PATH

```
/////GUIDE STILL IN WRITING PROCESS. NEXT UPDATE IN 8:00 AM PT/////