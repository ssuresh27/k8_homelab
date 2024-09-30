# curl -LO https://github.com/containernetworking/plugins/releases/download/v1.4.1/cni-plugins-linux-arm64-v1.4.1.tgz
# sudo mkdir -p /opt/cni/bin
# sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-arm64-v1.4.1.tgz

curl -LO https://github.com/containernetworking/plugins/releases/download/v1.5.1/cni-plugins-linux-amd64-v1.5.1.tgz
sudo mkdir -p /opt/cni/bin
sudo tar Cxzf /opt/cni/bin cni-plugins-linux-amd64-v1.5.1.tgz