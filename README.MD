# Kubernetes (k8) Home Lab

Setup Kubernetes cluster using mutlipass on Mac (ARM64) and windows (X86-64/amd64) for home lab with default OS hypervisor (MAC QEMU, Windows Hyper-V).
In addtion, create a NFS server to privission pvc for statefull apps.

**MAC setup is in-progress**


## VM Hardware Requirements
- 8 GB of RAM (Preferably 16 GB)
- 50 GB Disk space

## Requirments

- [Multipass for Mac/Windows](https://multipass.run/install)
- [UTM for MAC/Windows (Optional)](https://mac.getutm.app)
- [Oracle Virtualbox for MAC/Windows (Optional)](https://www.virtualbox.org/wiki/Downloads)

## Reference

- [K8 using kubeadm](https://blog.kubesimplify.com/kubernetes-on-apple-macbooks-m-series)
- [Setup NFS server of PVC in k8s](https://medium.com/@shatoddruh/kubernetes-how-to-install-the-nfs-server-and-nfs-dynamic-provisioning-on-azure-virtual-machines-e85f918c7f4b)
- [Create a new network for static IP](https://www.madalin.me/devops/2022/250/multipass-permanent-ip-private-network-hyperv-windows.html)

[MAC](mac-arm64/README.MD) **Inprogres**


[Windows](x86-64/README.MD)