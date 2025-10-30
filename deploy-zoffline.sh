ZWIFT_BASE=~/Documents/Zwift-offline
mkdir -p ${ZWIFT_BASE}/scripts
mkdir -p ${ZWIFT_BASE}/storage
cd ${ZWIFT_BASE}

cp zwift-update.sh ${ZWIFT_BASE}/scripts

# Add alias to .zshrc
cat >> ~/.zshrc <<EOF
alias zwift-on=~/Documents/Zwift-offline/scripts/zwift-on.sh
alias zwift-off=~/Documents/Zwift-offline/scripts/zwift-off.sh
alias zwift-update=~/Documents/Zwift-offline/scripts/zwift-update.sh
EOF
source ~/.zshrc


# Create zwift offline docker composed file
cat >> ${ZWIFT_BASE}/scripts/docker-compose.yml << EOF
version: "3.6"
services:
    zoffline:
         image: zoffline/zoffline:latest
         build:
             context: .
             dockerfile: Dockerfile
         container_name: zoffline
         environment:
            - TZ=Europe/London
         volumes:
            - ~/Documents/Zwift-offline/storage:/usr/src/app/zwift-offline/storage
         ports:
            - 80:80
            - 443:443
            - 3024:3024/udp
            - 3025:3025
#            - 53:53/udp
         restart: unless-stopped
EOF



# Modify hosts file 
sudo chmod 777 /etc/hosts
cat >> /etc/hosts << EOF
# Added by Zwift offline
127.0.0.1 us-or-rly101.zwift.com secure.zwift.com cdn.zwift.com launcher.zwift.com
EOF

# Zwift online script
cat >> zwift-on.sh <<EOF
cat /etc/hosts > ~/Downloads/host.bak 
sed 's/127.0.0.1 us-or-rly101.zwift.com/#127.0.0.1 us-or-rly101.zwift.com/g' ~/Downloads/host.bak >/etc/hosts
EOF

# Zwift offline script
cat >> zwift-off.sh <<EOF
cat /etc/hosts > ~/Downloads/host.bak 
sed 's/#127.0.0.1 us-or-rly101.zwift.com/127.0.0.1 us-or-rly101.zwift.com/g' ~/Downloads/host.bak >/etc/hosts
EOF

# Zwift offline Extra feature(Bots,Robopacer,leaderboards,etc.)
unzip bots.zip -d ${ZWIFT_BASE}


# Enable Zwift offline feature
touch ${ZWIFT_BASE}/storage/enable_bots.txt
touch ${ZWIFT_BASE}/storage/enable_ghosts.txt
touch ${ZWIFT_BASE}/storage/all_time_leaderboards.txt
touch ${ZWIFT_BASE}/storage/unlock_entitlements.txt
touch ${ZWIFT_BASE}/storage/unlock_all_equipment.txt
echo "127.0.0.1" > ${ZWIFT_BASE}/storage/server-ip.txt
echo "20" > ${ZWIFT_BASE}/storage/enable_bots.txt
cp ${ZWIFT_BASE}/storage/bot_teams.txt ${BASE_DIR}/storage/bot.txt


# Change zwift cert, import to Keychain and alwaystrust it.
wget https://github.com/zoffline/zwift-offline/raw/master/ssl/cert-zwift-com.pem
sed -n '29,53p' cert-zwift-com.pem >> ~/Library/Application\ Support/Zwift/data/cacert.pem

# Deploy zwift offline
chmod a+x ~/Documents/Zwift-offline/scripts/*.sh
zwift-update
