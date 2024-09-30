#!/bin/bash
# for i in $(seq 1 $2);
# do
#    multipass transfer -v -r configfiles ${1}${i}:/tmp/
#    multipass exec -n ${1}${i} -- sudo cp /tmp/configfiles/dns_records /etc/hosts
#    multipass exec -n ${1}${i} -- bash /tmp/configfiles/01_update_ip_tables.sh
#    multipass exec -n ${1}${i} -- bash /tmp/configfiles/02_install_containerd.sh
#    multipass exec -n ${1}${i} -- bash /tmp/configfiles/03_install_runc.sh
#    multipass exec -n ${1}${i} -- bash /tmp/configfiles/04_install_cni.sh
#    multipass exec -n ${1}${i} -- bash /tmp/configfiles/05_install_kube.sh
#    multipass exec -n ${1}${i} -- bash /tmp/configfiles/06_crictl.sh
# done
# sudo adduser ssuresh sudo
# sudo sh -c "echo 'ssuresh ALL=NOPASSWD: ALL' >> /etc/sudoers"
for host in '192.168.65.3' '192.168.65.4'
do
   scp -rp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null configfiles ssuresh@${host}:/home/ssuresh
   ssh ssuresh@${host} 'sudo swapoff -a'
   ssh ssuresh@${host} 'sudo sed -i '/swap/d' /etc/fstab'
   ssh ssuresh@${host} 'echo /swapfile none swap sw 0 0| sudo tee -a /etc/fstab > /dev/null'
   ssh ssuresh@${host} 'sudo cp /home/ssuresh/configfiles/dns_records /etc/hosts'
   ssh ssuresh@${host} 'bash /home/ssuresh/configfiles/01_update_ip_tables.sh'
   ssh ssuresh@${host} 'bash /home/ssuresh/configfiles/02_install_containerd.sh'
   ssh ssuresh@${host} 'bash /home/ssuresh/configfiles/03_install_runc.sh'
   ssh ssuresh@${host} 'bash /home/ssuresh/configfiles/04_install_cni.sh'
   ssh ssuresh@${host} 'bash /home/ssuresh/configfiles/05_install_kube.sh'
   ssh ssuresh@${host} 'bash /home/ssuresh/configfiles/06_crictl.sh'
   ssh ssuresh@${host} 'sudo rm /etc/containerd/config.toml'
   ssh ssuresh@${host} 'sudo systemctl restart containerd'
done