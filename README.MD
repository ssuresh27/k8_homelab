# Kubernetes (k8) Home Lab

Setup Kubernetes using mutlipass on Mac (ARM64) and windows (X86-64/amd64) for home lab, use OS hypervisor (MAC QEMU, Windows default)

**MAC setup is not working for time to time**

## Requirments

- [Multipass for Mac/Windows](https://multipass.run/install)
- [UTM for MAC/Windows (Optional)](https://mac.getutm.app)
- [Oracle Virtualbox for MAC/Windows Optional](https://www.virtualbox.org/wiki/Downloads)

## Reference

- [K8 using kubeadm](https://blog.kubesimplify.com/kubernetes-on-apple-macbooks-m-series)
- [Setup NFS server of PVC in k8](https://medium.com/@shatoddruh/kubernetes-how-to-install-the-nfs-server-and-nfs-dynamic-provisioning-on-azure-virtual-machines-e85f918c7f4b)

- [Create a new network for static IP]https://www.madalin.me/devops/2022/250/multipass-permanent-ip-private-network-hyperv-windows.html

```powershell

```

## Pre-requsites

#### Update VM Subnet in Makefile

**Mac** Modify file mac-arm64/mac_k8.mk

**Windows** Modify file x86-64/x86-64.mk

- Update CIDR Only three digits `IP_CIDR=192.168.65`
- Update WORKER_NODES count `WORKER_NODES=2`
- Update the Subnet in `07_initiate_master.sh` in `--apiserver-advertise-address=<subet>.111`, without this cluster initialization will fail.

**SSH Keys for direct access** in respective folder mac-arm64/x86-64

- Fom localhost `ssh-keygen -C ubuntu -f multipass-ssh-key`
- Copy Public key `~/.ssh/multipass-ssh-key` contents to file `cloud-init.yaml` under `ssh_authorized_keys`

**Permission of shell scripts**
chmod 755 configfiles/_.sh
chmod 755 _.sh

## To install the K8

Change to respective OS directoy mac-arm64 or x86-64

Create using the Makefile
**Mac**

```bash
make -f mac_k8.mk configure_all
```

**Windows**

```bash
make -f x86-64.mk configure_all
```

#### Copy the Kube config keys to local machine to connect

```bash
make -f mac_k8.mk setup_keys
```

#### Finally copy and run the kubeadm join to attache the worker nodes in cluster

In kubemaster1 /tmp/op/tmp/kubeadm_op.txt

#### Storage class with NFS already created

```powershell
Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Name 'vEthernet (multipass)').ifIndex

IPAddress         : 169.254.124.160
InterfaceIndex    : 18
InterfaceAlias    : vEthernet (multipass)

Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Name 'vEthernet (multipass)').ifIndex | Remove-NetIPAddress -confirm:$false
New-NetIPAddress -InterfaceAlias 'vEthernet (multipass)' -IPAddress '10.0.0.1' -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias 'vEthernet (multipass)' -ServerAddresses ("10.0.0.15","8.8.8.8")

PS C:\Git\k8_homelab> Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Name 'vEthernet (multipass)').ifIndex


IPAddress         : 10.0.0.1
InterfaceIndex    : 49
InterfaceAlias    : vEthernet (multipass)
```
