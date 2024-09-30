# sudo apt-get update
# sudo apt install net-tools nfs-common nfs-kernel-server socat -y
sudo apt install nfs-kernel-server -y 
sudo mkdir /data
sudo chown -R nobody:nogroup /data
sudo chmod -R 777 /data
echo '/data *(rw,sync,no_subtree_check)' |  sudo tee -a /etc/exports > /dev/null
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
sudo ufw allow from 192.168.56.111 to any port nfs
sudo ufw allow from 192.168.56.201 to any port nfs
sudo ufw allow from 192.168.56.202 to any port nfs
sudo ufw allow from 192.168.56.203 to any port nfs
sudo ufw allow from 192.168.56.204 to any port nfs
sudo ufw allow from 192.168.65.3 to any port nfs
sudo ufw allow from 192.168.65.4 to any port nfs
sudo ufw allow from 192.168.65.5 to any port nfs
sudo ufw allow from 192.168.65.6 to any port nfs