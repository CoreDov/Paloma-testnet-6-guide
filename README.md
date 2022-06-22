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
wget -O addrbook.json https://raw.githubusercontent.com/CoreDov/Paloma-testnet-5-guide/main/Assets/addrbook.json
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
### Configuring persistent peers:
```shell
PEERS="175ccd9b448390664ea121427aab20138cc8fcec@testnet.palomaswap.com:26656,175ccd9b448390664ea121427aab20138cc8fcec@testnet.palomaswap.com:26656,ae9abb5f65f5f17244371c2de1a2669902505b34@178.128.53.241:26656,b8c2757704ecf9c60cc76ecd1e33111082f5d8ba@38.242.213.87:26656,a67643d96fc1997940437eee74c7601e124624ac@161.97.132.212:26656,0f00653de7318d54a9944013492a834d5b3b3c28@52.207.234.246:26656,0fd16800f5a96f3e25babc44973b5659095ab3c6@38.242.238.107:26656,fae84ec72a6f686d76096053e0532a65b69e5228@143.198.169.111:26656,3a06e1d98f831963a09a16561c4125e4eec5ed06@195.3.223.33:30656,f9d0db52347811f07b0aab4047099281ed042533@88.208.57.200:36656,e1efddf3b39f1953590f8264d30d71d1a1313061@164.90.134.139:26656,301938da656d6224fdd35f806b1d2b67d94d8d36@34.69.131.169:26656,5d8e547ebe3c6b62a043f52ffc379898ce3ef578@128.199.229.55:36416,3a06e1d98f831963a09a16561c4125e4eec5ed06@195.3.223.33:30656,eb33a25834f0368c91bdc33c6178efa45b48e15f@142.93.222.212:36416,22ce759d389de8c0ef14710916ddba05246bce31@35.232.220.104:26656,368f268011d047a25ba1e658b29d8d68695eaefe@20.56.69.130:26656,ae9abb5f65f5f17244371c2de1a2669902505b34@178.128.53.241:26656,b8c2757704ecf9c60cc76ecd1e33111082f5d8ba@38.242.213.87:26656,a67643d96fc1997940437eee74c7601e124624ac@161.97.132.212:26656,0f00653de7318d54a9944013492a834d5b3b3c28@52.207.234.246:26656,0fd16800f5a96f3e25babc44973b5659095ab3c6@38.242.238.107:26656,6812a34e6ef2217662bdf3dfc031a102863c49a6@3.73.75.14:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.paloma/config/config.toml
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
$TIKER tx staking create-validator --amount=950000$TOKEN --pubkey=$($TIKER tendermint show-validator) --moniker=$MONIKER --chain-id=$CHAIN --commission-rate="0.10" --commission-max-rate="0.20" --commission-max-change-rate="0.01" --min-self-delegation="1" --fees=250$TOKEN --gas=200000 --from=$ADDRESS --identity=$IDENTITY --website=$WEBSITE --details=$DETAILS --node "tcp://testnet.palomaswap.com:26657" -y
```
# Useful commands:
### Check logs:
```shell
journalctl -u $TIKER -f -o cat
```
### Service status:
```shell
systemctl status $TIKER
```
### Node status:
```shell
curl -s $NODE/status
```
### Sync status
```shell
curl -s $NODE/status | jq .result.sync_info.catching_up
```
### Check connected peers:
```shell
curl -s $NODE/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr | split(":")[2])"' | wc -l
```
### Check validator address:
```shell
echo $VALOPER
```
### Check all wallets:
```shell
$TIKER keys list
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
### Send tokens
```shell
$TIKER tx bank send $WALLET <WALLET_TO> <TOKENS_COUNT>$TOKEN --fees 5000$TOKEN
```