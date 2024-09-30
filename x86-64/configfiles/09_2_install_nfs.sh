sudo mkdir -p /data
sudo mount nfsserver:/data /data
echo 'nfsserver:/data   /data   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0' | sudo sudo tee -a /etc/fstab > /dev/null
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
# helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
# helm install -n nfs-provisioning --create-namespace nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=nfsserver --set nfs.path=/data

helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --version v4.9.0