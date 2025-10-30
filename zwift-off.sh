cat /etc/hosts > ~/Downloads/host.bak 
sed 's/#127.0.0.1 us-or-rly101.zwift.com/127.0.0.1 us-or-rly101.zwift.com/g' ~/Downloads/host.bak >/etc/hosts
