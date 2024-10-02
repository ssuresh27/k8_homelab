# Kubernetes (k8) Home Lab For Windows

Setup Kubernetes cluster using mutlipass on Mac (ARM64) and windows (X86-64/amd64) for home lab with default OS hypervisor (MAC QEMU, Windows Hyper-V).
In addtion, create a NFS server to privission pvc for statefull apps.

## VM Hardware Requirements
- 8 GB of RAM (Preferably 16 GB)
- 50 GB Disk space

## Requirments

- [Multipass for Mac/Windows](https://multipass.run/install)

## **Windows**

- Create a new private subnet in Windows Hyper-V for static IP
- if the static ip subnet is in 169.0.0.0, k8 cluster will not work. Use below to change the subnet

```powershell
Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Name 'vEthernet (multipass)').ifIndex

*IPAddress         : 169.254.124.160*
InterfaceIndex    : 18
InterfaceAlias    : vEthernet (multipass)

Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Name 'vEthernet (multipass)').ifIndex | Remove-NetIPAddress -confirm:$false
New-NetIPAddress -InterfaceAlias 'vEthernet (multipass)' -IPAddress '10.0.0.1' -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias 'vEthernet (multipass)' -ServerAddresses ("10.0.0.15","8.8.8.8")

Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Name 'vEthernet (multipass)').ifIndex

*IPAddress         : 10.0.0.1*
InterfaceIndex    : 49
InterfaceAlias    : vEthernet (multipass)
```

##### Install openssh in Windows & WSL to connect from another computer (Optional)

- [Install openssh in Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell&pivots=windows-server-2019)
- Install openssh in WSL
```bash
sudo apt-get install openssh-server
sudo systemctl enable --now ssh
```

##### Install k9s on WSL (Optional)

``` bash
cd ~
curl -L https://github.com/derailed/k9s/releases/download/v0.21.4/k9s_Linux_x86_64.tar.gz -o k9s
tar -xf k9s
chmod +x k9s
sudo mv ./k9s /usr/local/bin/k9s
k9s
```

#### Connect remote WSL (Optional)
[Remote WSL in vscode](https://gist.github.com/mattbell87/f5bd7b78c8d0ad7f0dfc3addae4f4897)
**Proxy jump method**
- On the host set up OpenSSH for Windows
- Run wsl --update to make sure you are running the latest WSL
- Open WSL and install another SSH server inside WSL with sudo apt-get install openssh-server
- Now run sudo systemctl enable --now ssh to automatically start ssh when WSL starts.
- On the remote machine run ssh -J windows_user@windows_ip wsl_user@localhost to see if the proxy jump will work

If you see the bash prompt it works. You can add it to the ~/.ssh/config file on the remote machine.

```bash
Host remote-wsl
  HostName localhost
  User wsl_user
  ProxyJump windows_user@windows_ip
  StrictHostKeyChecking no
```


#### Create SSH Key to connect cluster nodes via ssh
``` bash
ssh-keygen -t rsa
cat .ssh/id_rsa.pub
```
Add public key to `ssh_authorized_keys` in `cloud-init-win.yaml`, `cloud-init-win-nfs.yaml`

Update below values in k8_install.ps1. If mutlipas failed to launch one or mode vm update i values accordinly start right sequence

```bash
$subnet
$i = 1
$control = 1
$worker = 3
$nfs = 1
```

**run powershell script** This will create the required VMs with kubectl, containerd and other pre-requsites mentioned in cloud-init file
```powershell
./k8_install.ps1
```


#### Initialize the contol plane
On `contol01` vm

```bash
multipass shell control01 or 
ssh ubuntu@10.0.0.111
```

**update the api(controlserver ip) if your subnet is not 10.0.0**
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.0.0.111 > /home/ubuntu/kubeadm_op.txt
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.30/net.yaml
sudo cat /tmp/kubeadm_op.txt
```

#### Initialize worker nodes
On `all worker` vms run the kubeadm join

```bash
multipass shell worker01 or 
ssh ubuntu@10.0.0.201
```


### To setup NFS server 

On `contol01` vm **update the nfsserver if if your subnet is not 10.0.0** 

```bash 
multipass shell control01 or 
ssh ubuntu@10.0.0.111
sudo mkdir -p /data
sudo mount 10.0.0.199:/data /data
echo '10.0.0.199:/data   /data   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo sudo tee -a /etc/fstab > /dev/null
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
# helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
# helm install -n nfs-provisioning --create-namespace nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=nfsserver --set nfs.path=/data

helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --version v4.9.0
```


And create a storage class and test pvc & pod

```bash
kubectl apply -f sc/nfs-storageclass.yaml
kubectl apply -f sc/test-pvc.yaml
kubectl apply -f sc/test-pvc-pod.yaml
```