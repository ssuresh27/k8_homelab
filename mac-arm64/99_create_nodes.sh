multipass launch --disk 10G --memory 2G --cpus 2 --name kubemaster1 --cloud-init cloud-init.yaml --network name=en0,mode=manual,mac="52:54:00:D4:88:A5" noble
./03_create_network.sh kubemaster1 52:54:00:D4:88:A5 192.168.65.111
multipass launch --disk 10G --memory 2G --cpus 2 --name kubeworker1 --cloud-init cloud-init.yaml --network name=en0,mode=manual,mac="52:54:00:09:2F:EC" noble
./03_create_network.sh kubeworker1 52:54:00:09:2F:EC 192.168.65.201
multipass launch --disk 20G --memory 2G --cpus 2 --name nfsserver --cloud-init cloud-init.yaml --network name=en0,mode=manual,mac="52:54:00:F6:68:C1" noble
./03_create_network.sh nfsserver 52:54:00:F6:68:C1 192.168.65.199
