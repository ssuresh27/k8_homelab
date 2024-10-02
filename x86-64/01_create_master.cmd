#!/bin/bash
IP_CIDR=$2
#https://superuser.com/questions/1172640/local-mac-address-generator#:~:text=mac%3D%24%28for%20i%20in%20%7B1..10%7D%20%3B%20do%20echo%20-n,This%20will%20generate%20all%20possible%20local%20MAC%20addresses.
#https://www.madalin.me/devops/2022/250/multipass-permanent-ip-private-network-hyperv-windows.html
mac_random()
{
    localoctet="26AE"
    hexchars="0123456789ABCDEF"
    local=$( echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; echo -n ${localoctet:$(( $RANDOM % 4 )):1} )
    mac=$( for i in {1..10} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
    random_mac=$local$mac
    echo "${random_mac}"
}

for i in $(seq 1 $1);
do
    # echo $i
    # MACADDR=$(echo 52:54:00$(format-hex -n3 -e '/1 ":%02X"' /dev/random)); export MACADDR
    MACADDR=$(mac_random)
    echo $MACADDR
    CREATE_NODE=$(echo "multipass launch --disk 10G \
    --memory 2G \
    --cpus 2 \
    --name kubemaster${i} \
    --cloud-init cloud-init.yaml \
    --network name=multipass,mode=manual,mac=\"${MACADDR}\" \
    noble")
    echo ${CREATE_NODE} >> 99_create_nodes.sh
    echo "./03_create_network.sh kubemaster${i} ${MACADDR} ${IP_CIDR}.10${i}" >> 99_create_nodes.sh
    echo "${IP_CIDR}.11${i} kubemaster${i} " >> configfiles/dns_records
    
    # CREATE_NODE_REMOVE_QUOTE=$(echo ${CREATE_NODE}); export CREATE_NODE_REMOVE_QUOTE
    # echo ${CREATE_NODE_REMOVE_QUOTE}
done
chmod 755 99_create_nodes.sh