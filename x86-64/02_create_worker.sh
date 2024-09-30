#!/bin/bash
# echo > create_nodes.sh
# chmod 755 create_nodes.sh
IP_CIDR=$2
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
    # MACADDR=$(echo 52:54:00$(hexdump -n3 -e '/1 ":%02X"' /dev/random)); export MACADDR
    MACADDR=$(mac_random)
    # echo $MACADDR
    CREATE_NODE=$(echo "multipass launch --disk 10G \
    --memory 2G \
    --cpus 2 \
    --name kubeworker${i} \
    --cloud-init cloud-init.yaml \
    --network name=multipass,mode=manual,mac=\"${MACADDR}\" \
    noble")
    echo ${CREATE_NODE} >> 99_create_nodes.sh
    echo "./03_create_network.sh kubeworker${i} ${MACADDR} ${IP_CIDR}.11${i}" >> 99_create_nodes.sh
    echo "${IP_CIDR}.20${i} kubeworker${i} " >> configfiles/dns_records
    # CREATE_NODE_REMOVE_QUOTE=$(echo ${CREATE_NODE}); export CREATE_NODE_REMOVE_QUOTE
    # echo ${CREATE_NODE_REMOVE_QUOTE}
done