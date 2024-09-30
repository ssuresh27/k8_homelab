#!/bin/bash
# multipass transfer -v -r configfiles/ nfsserver:/tmp/
# multipass exec -n nfsserver -- bash /tmp/configfiles/09_1_install_nfs.sh
# multipass exec -n kubemaster1 -- bash /tmp/configfiles/09_2_install_nfs.sh

# for host in '192.168.65.101'
# do
#    scp -rp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null configfiles ssuresh@${host}:/home/ssuresh
#    ssh ssuresh@${host} 'sudo swapoff -a'
#    ssh ssuresh@${host} 'sudo cp /home/ssuresh/configfiles/dns_records /etc/hosts'
#    ssh ssuresh@${host} 'bash /home/ssuresh/configfiles/09_1_install_nfs.sh'
# done
for host in '192.168.65.3'
do
   ssh ssuresh@${host} 'bash /home/ssuresh/configfiles/09_2_install_nfs.sh'
done