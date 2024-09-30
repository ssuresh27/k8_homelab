#!/bin/bash
IP_CIDR=$1
MACADDR=$(echo 52:54:00$(hexdump -n3 -e '/1 ":%02X"' /dev/random)); export MACADDR
# echo $MACADDR
CREATE_NODE=$(echo "multipass launch --disk 20G \
--memory 2G \
--cpus 2 \
--name nfsserver \
--cloud-init cloud-init.yaml \
--network name=en0,mode=manual,mac=\"${MACADDR}\" \
noble")
echo ${CREATE_NODE} >> 99_create_nodes.sh
echo "./03_create_network.sh nfsserver ${MACADDR} ${IP_CIDR}.199" >> 99_create_nodes.sh
echo "${IP_CIDR}.199 nfsserver" >> configfiles/dns_records