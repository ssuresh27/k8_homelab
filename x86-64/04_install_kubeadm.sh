#!/bin/bash
# for i in $(seq 1 $2);
# do
   # multipass transfer -v -r configfiles ${1}${i}:/home/ubuntu
   # multipass exec -n ${1}${i} -- bash confilfiles/install_all.sh
   # multipass exec -n ${1}${i} -- bash configfiles/00_dns_records.sh
   # multipass exec -n ${1}${i} -- bash configfiles/01_update_ip_tables.sh
   # multipass exec -n ${1}${i} -- bash configfiles/02_install_containerd.sh
   # multipass exec -n ${1}${i} -- bash configfiles/03_install_runc.sh
   # multipass exec -n ${1}${i} -- bash configfiles/04_install_cni.sh
   # multipass exec -n ${1}${i} -- bash configfiles/05_install_kube.sh
   # multipass exec -n ${1}${i} -- bash configfiles/06_crictl.sh
# done

ip=$2
node=$1
sftp -i ~/.ssh/multipass-ssh-key ubuntu@${ip}> /dev/null << COMMANDS
put -r configfiles
quit
COMMANDS
multipass exec -n ${node} -- bash configfiles/install_all.sh