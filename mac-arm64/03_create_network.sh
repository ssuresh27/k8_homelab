node=$1
mac=$2
ip=$3

echo "network:
  version: 2
  ethernets:
    extra0:
      dhcp4: no
      match:
        macaddress: \"${mac}\"
      addresses: [$ip/24]" > 10-custom.yaml

multipass transfer 10-custom.yaml ${node}:/tmp/10-custom.yaml
multipass exec -n ${node} -- sudo cp /tmp/10-custom.yaml  /etc/netplan/10-custom.yaml
multipass exec -n ${node} -- sudo netplan apply