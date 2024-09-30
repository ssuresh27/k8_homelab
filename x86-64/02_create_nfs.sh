# https://medium.com/@shatoddruh/kubernetes-how-to-install-the-nfs-server-and-nfs-dynamic-provisioning-on-azure-virtual-machines-e85f918c7f4b
#!/bin/bash
IP_CIDR=$1
mac_random()
{
    localoctet="26AE"
    hexchars="0123456789ABCDEF"
    local=$( echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; echo -n ${localoctet:$(( $RANDOM % 4 )):1} )
    mac=$( for i in {1..10} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
    random_mac=$local$mac
    echo "${random_mac}"
}
# MACADDR=$(echo 52:54:00$(hexdump -n3 -e '/1 ":%02X"' /dev/random)); export MACADDR
# echo $MACADDR
MACADDR=$(mac_random)
CREATE_NODE=$(echo "multipass launch --disk 20G \
--memory 2G \
--cpus 2 \
--name nfsserver \
--cloud-init cloud-init.yaml \
--network name=multipass,mode=manual,mac=\"${MACADDR}\" \
noble")
echo ${CREATE_NODE} >> 99_create_nodes.sh
echo "./03_create_network.sh nfsserver ${MACADDR} ${IP_CIDR}.199" >> 99_create_nodes.sh
echo "${IP_CIDR}.199 nfsserver" >> configfiles/dns_records