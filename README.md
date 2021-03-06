# Paloma-testnet-6 node instalation guide
### Hardware requirements:

CPU	4 theads

RAM	16GB

Storage	SSD 200GB

Bandwidth: 1 Gbps for Download/100 Mbps for Upload

# Manual instalation:
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
CHAIN=paloma-testnet-6
TOKEN=ugrain
PROJECT=palomad
CONFIG=.paloma
NODE=http://localhost:26657
GENESIS_JSON_PATH=https://raw.githubusercontent.com/palomachain/testnet/master/paloma-testnet-6/genesis.json
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
wget -O - https://github.com/palomachain/paloma/releases/download/v0.2.5-prealpha/paloma_0.2.5-prealpha_Linux_x86_64.tar.gz | \
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
### Saving variables:
```shell
VALOPER=$($TIKER keys show $WALLET --bech val -a)
ADDRESS=$($TIKER keys show $WALLET --address)
echo "export VALOPER=$VALOPER" >> $HOME/.bash_profile
echo "export ADDRESS=$ADDRESS" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
### Downloading genesis and adddrbook:
```shell
cd $HOME/$CONFIG/config
wget -O genesis.json $GENESIS_JSON_PATH
wget -O addrbook.json https://raw.githubusercontent.com/CoreDov/Paloma-testnet-6-guide/main/Assets/addrbook.json
```
## Starting node:
### Creating and configuring service file:
```shell
sudo tee /etc/systemd/system/$TIKER.service > /dev/null <<EOF
[Unit]
Description=$PROJECT Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which $TIKER) start
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Configuring persistent peers (SKIP IT):
```shell
PEERS="b4cc45912500248a5648952c722ed631bf76cf79@38.242.241.201:26656,00daff14979a2d5fc91a39d1157c5444e74e2e41@38.242.128.145:26656,0f4e2cac1fc1a83e8610660da5e1b16cd5f5edb9@164.68.118.227:26656,2954b34ef577bbb310d31cc57ccb9ecda7e180d6@173.212.238.31:26656,e0a5a7a9eab2c04ad6cf0c01df7cac74b32c4a72@138.201.139.175:20456,8fb204fbb55695f263867cb5f416cce9bcc5c890@161.97.107.147:46656,1ccf9c42f886dc86fbae888eaee9f08f9ca475a3@95.216.171.152:26656,175ccd9b448390664ea121427aab20138cc8fcec@testnet.palomaswap.com:26656,c8c88afce29bd3f9b68dcbba6acf7100210cdc09@65.21.181.135:36656,d6ee6c3ccc5d307600fc9d01619b4eae2ad331da@217.79.187.35:26656,98bbed8647e2bd80d169ed7ae04e41e82f24594f@65.21.181.135:36656,b159364b4e6a3036c36ef6c7c690c5fbc81fa9c4@65.108.71.92:54056,3f053da998299894a4574720629780fcafa5875c@138.201.139.175:20456,e4b7cdd48c39c355e9a3480f4f4d5afab8fb0e08@46.0.203.78:26637,983c19423a0c9a4a444d6ccd76a73ecac523b868@78.47.128.136:26656,26f67d710b591bb2b7efd4f339daac56ca5e7e41@194.163.172.204:26656,a25f8bc10d9b3834e2834ac8231152fa862e7160@38.242.242.189:36416,68e4fb7ed3c792a3cf6f8c43d984d23c513b66f4@146.19.24.34:16656"

sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.paloma/config/config.toml
```
### Starting service:
```shell
sudo systemctl daemon-reload
sudo systemctl enable $TIKER
sudo systemctl restart $TIKER

#check logs:
sudo journalctl -u $TIKER -f -o cat
```
# Creating validator:
after you have started the node you must wait until it synchronizes with the network. You can check the synchronization status with this command:
```shell
curl -s $NODE/status | jq .result.sync_info.catching_up
```
if catching_up=true, your node is still syncing. Usually synchronization takes 5-10 minutes. If during this time it has not been synchronized, then you need to check the logs to understand what the problem is. You can check the logs by issuing this command:
```shell
journalctl -u $TIKER -f -o cat
```
if something like this happens in the logs:
```shell
6:19PM ERR Failed to reconnect to peer. Beginning exponential backoff 
addr={"id":"8980faac5295875a5ecd987a99392b9da56c9848","ip":"85.10.216.151","port":26656} 
elapsed=193577.896484 module=p2p
6:14PM INF Dialing peer address={"id":"111ba4e5ae97d5f294294ea6ca03c17506465ec5","ip":"208.68.39.221",
"port":26656} module=p2p
6:14PM INF Error reconnecting to peer. Trying again addr={"id":"111ba4e5ae97d5f294294ea6ca03c17506465ec5",
"ip":"208.68.39.221","port":26656} err="dial tcp 208.68.39.221:26656: i/o timeout" module=p2p tries=17
```
This means that your node cannot connect to peers. For a list of current peers and address books, you can contact the official channel of the project.

If your node has synced then the sync status should change to catching_up=false

After synchronization, you must request tokens to create a validator. If faucet not working, you must request tokens in the project's telegram group. To find out the address of your wallet if you forgot it, you can use this command:
```shell
$TIKER keys list
```
If the faucet is currently running, then tokens can be requested on the website https://faucet.palomaswap.com/

You can check the availability of tokens on the wallet with this command:
```shell
$TIKER q bank balances $ADDRESS
```
if the tokens came to your wallet, then you can proceed to the next step
### Creating validator:
To create a validator, you need to run this command:
```shell
$TIKER tx staking create-validator --amount=950000$TOKEN --pubkey=$($TIKER tendermint show-validator) --moniker=$MONIKER --chain-id=$CHAIN --commission-rate="0.10" --commission-max-rate="0.20" --commission-max-change-rate="0.01" --min-self-delegation="1" --fees=250$TOKEN --gas=200000 --from=$ADDRESS --identity=$IDENTITY --website=$WEBSITE --details=$DETAILS -y
```
# Useful commands:
### Check logs:
```shell
journalctl -u $TIKER -f -o cat
```
### Node status:
```shell
curl -s $NODE/status
```
### Sync status
```shell
curl -s $NODE/status | jq .result.sync_info.catching_up
```
### Check validator address:
```shell
echo $VALOPER
```
### Check all wallets:
```shell
$TIKER keys list
```
### Send tokens
```shell
$TIKER tx bank send $WALLET <WALLET_TO> <TOKENS_COUNT>$TOKEN --fees 5000$TOKEN
```
### Check wallet balance:
```shell
$TIKER q bank balances $ADDRESS
```
### Unjail:
```shell
$TIKER tx slashing unjail --from $WALLET --fees 5000$TOKEN
```
### Delegate:
```shell
$TIKER tx staking delegate $VALOPER <TOKENS_COUNT>$TOKEN --from $WALLET --fees 5000$TOKEN -y
```
### Undelegate:
```shell
$TIKER tx staking unbond $VALOPER <TOKENS_COUNT>$TOKEN --from $WALLET --fees 5000$TOKEN -y
```
