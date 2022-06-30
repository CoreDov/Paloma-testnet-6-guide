echo -e '╔══╗╔══╗╔═══╗╔═══╗╔══╗─╔══╗╔╗╔╗' && sleep 0.15
echo -e '║╔═╝║╔╗║║╔═╗║║╔══╝║╔╗╚╗║╔╗║║║║║' && sleep 0.15
echo -e '║║──║║║║║╚═╝║║╚══╗║║╚╗║║║║║║║║║' && sleep 0.15
echo -e '║║──║║║║║╔╗╔╝║╔══╝║║─║║║║║║║╚╝║' && sleep 0.15
echo -e '║╚═╗║╚╝║║║║║─║╚══╗║╚═╝║║╚╝║╚╗╔╝' && sleep 0.15
echo -e '╚══╝╚══╝╚╝╚╝─╚═══╝╚═══╝╚══╝─╚╝' && sleep 0.15
echo -e ''
echo -e 'Paloma node auto installer by CoreDov (Boroda Validator) Version 0.2.4.f2 (EXPERIMENTAL)' && sleep 3
echo -e '\n\e[42mUpdating all packages...\e[0m\n' && sleep 1
sudo apt update && sudo apt upgrade -y
echo -e '\n\e[42mInstalling Important packages...\e[0m\n' && sleep 1
apt install jq -y

read -p "Enter your node name: " MONIKER
read -p "Enter your wallet name: " WALLET
read -p "Enter website that will be displayed on the validator page in the explorer(optional): " WEBSITE
read -p "Enter your 16-digit code from keybase.io for setting avatar of your validator(optional): " IDENTITY

echo -e '\n\e[42mImporting Variables\e[0m\n' && sleep 1
TIKER=palomad && \
CHAIN=paloma-testnet-5 && \
TOKEN=ugrain && \
PROJECT=palomad && \
CONFIG=.paloma && \
NODE=http://localhost:26657 && \
GENESIS_JSON_PATH=https://raw.githubusercontent.com/palomachain/testnet/master/paloma-testnet-5/genesis.json 

echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile && \
echo "export WALLET=$WALLET" >> $HOME/.bash_profile && \
echo "export WEBSITE=$WEBSITE" >> $HOME/.bash_profile && \
echo "export IDENTITY=$IDENTITY" >> $HOME/.bash_profile && \
echo "export TIKER=$TIKER" >> $HOME/.bash_profile && \
echo "export CHAIN=$CHAIN" >> $HOME/.bash_profile && \
echo "export TOKEN=$TOKEN" >> $HOME/.bash_profile && \
echo "export PROJECT=$PROJECT" >> $HOME/.bash_profile && \
echo "export CONFIG=$CONFIG" >> $HOME/.bash_profile && \
echo "export NODE=$NODE" >> $HOME/.bash_profile && \
echo "export GENESIS_JSON_PATH=$GENESIS_JSON_PATH" >> $HOME/.bash_profile && \
source $HOME/.bash_profile

echo -e '\n\e[42mInstalling Binaries...\e[0m\n' && sleep 1
wget -O - https://github.com/palomachain/paloma/releases/download/v0.2.4-prealpha/paloma_0.2.4-prealpha_Linux_x86_64.tar.gz | \
sudo tar -C /usr/local/bin -xvzf - palomad
sudo chmod +x /usr/local/bin/palomad
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/raw/main/api/libwasmvm.x86_64.so

$TIKER init $MONIKER --chain-id $CHAIN
$TIKER config chain-id $CHAIN
$TIKER config keyring-backend test
$TIKER config node $NODE

echo -e '\n\e[41m//////SAVE MNEMONIC OF YOUR WALLET//////\e[0m\n' && sleep 1
$TIKER keys add $WALLET
echo -e '\n\e[41m////////////////////////////////////////\e[0m\n' && sleep 5

VALOPER=$($TIKER keys show $WALLET --bech val -a) && \
ADDRESS=$($TIKER keys show $WALLET --address) && \
echo "export VALOPER=$VALOPER" >> $HOME/.bash_profile && \
echo "export ADDRESS=$ADDRESS" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
cd $HOME/$CONFIG/config

wget -O genesis.json $GENESIS_JSON_PATH
wget -O addrbook.json https://raw.githubusercontent.com/CoreDov/Paloma-testnet-5-guide/main/Assets/addrbook.json
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

PEERS="175ccd9b448390664ea121427aab20138cc8fcec@testnet.palomaswap.com:26656,175ccd9b448390664ea121427aab20138cc8fcec@testnet.palomaswap.com:26656,ae9abb5f65f5f17244371c2de1a2669902505b34@178.128.53.241:26656,b8c2757704ecf9c60cc76ecd1e33111082f5d8ba@38.242.213.87:26656,a67643d96fc1997940437eee74c7601e124624ac@161.97.132.212:26656,0f00653de7318d54a9944013492a834d5b3b3c28@52.207.234.246:26656,0fd16800f5a96f3e25babc44973b5659095ab3c6@38.242.238.107:26656,fae84ec72a6f686d76096053e0532a65b69e5228@143.198.169.111:26656,3a06e1d98f831963a09a16561c4125e4eec5ed06@195.3.223.33:30656,f9d0db52347811f07b0aab4047099281ed042533@88.208.57.200:36656,e1efddf3b39f1953590f8264d30d71d1a1313061@164.90.134.139:26656,301938da656d6224fdd35f806b1d2b67d94d8d36@34.69.131.169:26656,5d8e547ebe3c6b62a043f52ffc379898ce3ef578@128.199.229.55:36416,3a06e1d98f831963a09a16561c4125e4eec5ed06@195.3.223.33:30656,eb33a25834f0368c91bdc33c6178efa45b48e15f@142.93.222.212:36416,22ce759d389de8c0ef14710916ddba05246bce31@35.232.220.104:26656,368f268011d047a25ba1e658b29d8d68695eaefe@20.56.69.130:26656,ae9abb5f65f5f17244371c2de1a2669902505b34@178.128.53.241:26656,b8c2757704ecf9c60cc76ecd1e33111082f5d8ba@38.242.213.87:26656,a67643d96fc1997940437eee74c7601e124624ac@161.97.132.212:26656,0f00653de7318d54a9944013492a834d5b3b3c28@52.207.234.246:26656,0fd16800f5a96f3e25babc44973b5659095ab3c6@38.242.238.107:26656,6812a34e6ef2217662bdf3dfc031a102863c49a6@3.73.75.14:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.paloma/config/config.toml
sudo systemctl daemon-reload
sudo systemctl enable $TIKER
sudo systemctl restart $TIKER

echo -e '\n\e[42mChecking all variables:\e[0m\n' && sleep 1
echo -e '\n\e[42mValoper:\e[0m\n' && sleep 1
echo $VALOPER
echo -e '\n\e[42mWallet address:\e[0m\n' && sleep 1
echo $ADDRESS
echo -e '\n\e[42mProject name:\e[0m\n' && sleep 1
echo $PROJECT
echo -e '\n\e[42mtiker:\e[0m\n' && sleep 1
echo $TIKER 
echo -e "\e[31mIf your variables (Valoper,Wallet address, project name and tiker) was not shown pleade report this issue to developer @CoreDov (telegram) or create issue on github repository\e[39m"
echo -e '\n\e[42mChecking node status...\e[0m\n' && sleep 1
if [[ `service palomad status | grep active` =~ "running" ]]; then
  echo -e "Your Paloma node \e[32minstalled and works\e[39m!"
  echo -e "You can check node sync status by the command \e[7curl -s $NODE/status | jq .result.sync_info.catching_up\e[0m"
  echo -e "You can check node logs by the command \e[7journalctl -u palomad -f -o cat\e[0m"
  echo -e "You can check node status by the command \e[7service palomad status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Paloma node \e[31mwas not installed correctly\e[39m, please reinstall."
fi

#Dev zone

TIKER=palomad && \
CHAIN=paloma-testnet-5 && \
TOKEN=ugrain && \
PROJECT=palomad && \
CONFIG=.paloma && \
NODE=http://localhost:26657 && \
GENESIS_JSON_PATH=https://raw.githubusercontent.com/palomachain/testnet/master/paloma-testnet-5/genesis.json 
echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile && \
echo "export WALLET=$WALLET" >> $HOME/.bash_profile && \
echo "export WEBSITE=$WEBSITE" >> $HOME/.bash_profile && \
echo "export IDENTITY=$IDENTITY" >> $HOME/.bash_profile && \
echo "export TIKER=$TIKER" >> $HOME/.bash_profile && \
echo "export CHAIN=$CHAIN" >> $HOME/.bash_profile && \
echo "export TOKEN=$TOKEN" >> $HOME/.bash_profile && \
echo "export PROJECT=$PROJECT" >> $HOME/.bash_profile && \
echo "export CONFIG=$CONFIG" >> $HOME/.bash_profile && \
echo "export NODE=$NODE" >> $HOME/.bash_profile && \
echo "export GENESIS_JSON_PATH=$GENESIS_JSON_PATH" >> $HOME/.bash_profile && \
source $HOME/.bash_profile
VALOPER=$($TIKER keys show $WALLET --bech val -a) && \
ADDRESS=$($TIKER keys show $WALLET --address) && \
echo "export VALOPER=$VALOPER" >> $HOME/.bash_profile && \
echo "export ADDRESS=$ADDRESS" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
cd $HOME/$CONFIG/config