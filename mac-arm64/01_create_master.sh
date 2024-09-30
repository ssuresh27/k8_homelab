#!/bin/bash
IP_CIDR=$2
for i in $(seq 1 $1);
do
    # echo $i
    MACADDR=$(echo 52:54:00$(hexdump -n3 -e '/1 ":%02X"' /dev/random)); export MACADDR
    # echo $MACADDR
    CREATE_NODE=$(echo "multipass launch --disk 10G \
    --memory 2G \
    --cpus 2 \
    --name kubemaster${i} \
    --cloud-init cloud-init.yaml \
    --network name=en0,mode=manual,mac=\"${MACADDR}\" \
    noble")
    echo ${CREATE_NODE} >> 99_create_nodes.sh
    echo "./03_create_network.sh kubemaster${i} ${MACADDR} ${IP_CIDR}.11${i}" >> 99_create_nodes.sh
    echo "${IP_CIDR}.11${i} kubemaster${i} " >> configfiles/dns_records
    
    # CREATE_NODE_REMOVE_QUOTE=$(echo ${CREATE_NODE}); export CREATE_NODE_REMOVE_QUOTE
    # echo ${CREATE_NODE_REMOVE_QUOTE}
done
chmod 755 99_create_nodes.sh