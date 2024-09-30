sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=169.254.124.101 > /tmp/kubeadm_op.txt
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.30/net.yaml

sudo cat /tmp/kubeadm_op.txt