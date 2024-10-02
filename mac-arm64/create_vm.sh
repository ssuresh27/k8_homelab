#!/bin/zsh
create_vm()
{
    echo "Creating ${1} node.."
    MACADDR=$(echo 52:54:00$(hexdump -n3 -e '/1 ":%02X"' /dev/random)); export MACADDR
    echo $MACADDR
    multipass launch --disk 10G --memory 2G --cpus 2 --name $1 --cloud-init $2 --network name=en0,mode=manual,mac=\"${MACADDR}\" noble

yamlContent="network:
  version: 2
  ethernets:
    ens0p1:
      dhcp4: no
      match:
        macaddress: \"${MACADDR}\"
      addresses: [${3}/20]"

echo "$yamlContent" > "10-custom_${1}.yaml"
sleep 10
multipass transfer "10-custom_${1}.yaml" "${1}:10-custom.yaml"
multipass exec "${1}" -- sudo cp /home/ubuntu/10-custom.yaml /etc/netplan/
multipass exec "${1}" -- sudo chmod 600 /etc/netplan/10-custom.yaml
}

# Control nodes
MAX=1
for (( i=1; i<=MAX; i++ )) ;
do
  create_vm control0${i} cloud-init-arm64.yaml 192.168.65.10${i}
done

#Worker nodes
MAX=0
for (( i=1; i<=MAX; i++ )) ;
do
  create_vm worker0${i} cloud-init-arm64.yaml 192.168.65.11${i}
done

# NFS nodes
MAX=0
for (( i=1; i<=MAX; i++ )) ;
do
  create_vm nfsserver cloud-init-arm64-nfs.yaml 192.168.65.199
done