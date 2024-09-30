node=$1
mac=$2
ip=$3

# echo "network:
#   version: 2
#   ethernets:
#     eth1:
#       dhcp4: no
#       match:
#         macaddress: \"${mac}\"
#       addresses: [$ip/24]" > ./10-custom.yaml

# sftp -i ~/.ssh/multipass-ssh-key ubuntu@${ip}> /dev/null << COMMANDS
# put 10-custom.yaml
# put copy_nw.sh
# quit
# COMMANDS

# multipass transfer ./10-custom.yaml ${node}:/home/ubuntu/10-custom.yaml
# multipass transfer ./copy_nw.sh ${node}:/home/ubuntu/copy_nw.sh
# multipass exec -n ${node} -- bash copy_nw.sh
# multipass exec -n ${node} -- sudo netplan apply
#NetPlan taking longer, restart not releasing old IP on eht1
# multipass stop ${node}
# multipass start ${node}



multipass exec -n ${node} -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
  version: 2
  ethernets:
    extra0:
      dhcp4: no
      match:
        macaddress: '\"${mac}\"'
      addresses: '[$ip/24]'
EOF'
# multipass stop ${node}
# multipass start ${node}