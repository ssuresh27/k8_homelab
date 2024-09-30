CONTROL_NODES=1
WORKER_NODES=2
IP_CIDR=192.168.65
remove_file:
	rm ./99_create_nodes.sh configfiles/dns_records | true
create_localhost: remove_file 
	echo "127.0.0.1 localhost" > configfiles/dns_records
create_master: create_localhost
	./01_create_master.sh $(CONTROL_NODES) $(IP_CIDR)
create_worker:
	./02_create_worker.sh $(WORKER_NODES) $(IP_CIDR)
create_nfs:
	./02_create_nfs.sh $(IP_CIDR)

generate_scripts: create_master create_worker create_nfs

create_nodes: generate_scripts
	./99_create_nodes.sh

install_kubeadm_master: 
	./04_install_kubeadm.sh kubemaster $(CONTROL_NODES)

install_kubeadm_worker:
	./04_install_kubeadm.sh kubeworker $(WORKER_NODES)

install_nfs:
	./04_install_kubeadm.sh kubeworker $(WORKER_NODES)


install_kubeadm: create_nodes install_kubeadm_master install_kubeadm_worker install_nfs

configure_master: install_kubeadm
# configure_master: 
	./05_configure_master.sh kubemaster $(CONTROL_NODES)


# configure_worker: install_kubeadm_worker

configure_all: configure_master
	
setup_keys:
	 multipass transfer kubemaster1:/home/ubuntu/.kube/config ~/.kube

delete_all: stop_all
	multipass delete --all &
	multipass purge

stop_all:
	multipass stop --all

generate_master_scripts: create_master

ceate_master_node: generate_master_scripts
	./99_create_nodes.sh

install_control: ceate_master_node install_kubeadm_master

start_all:
	multipass start kubemaster1 &
	multipass start kubeworker1 &
	multipass start kubeworker2