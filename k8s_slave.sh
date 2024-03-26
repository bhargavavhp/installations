echo "############ Installing pre-requisites ############"
sudo apt update
sudo apt -y install curl apt-transport-https
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "############ Installing k8s components ############"
sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "############ Installed kubectl version ############"
kubectl version --client && kubeadm version

echo "############ Setting swap off ###########"
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

echo "############ Copying Kubernetes.conf ############"
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

echo "############ Reload Daemon ############"
sudo sysctl --system

echo "############ Installing containerd and Docker ############"
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io docker-ce docker-ce-cli

sudo mkdir -p /etc/systemd/system/docker.service.d

echo "############ Copying Docker Daemon json file ##########"
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

echo "############ Reload Daemon and enable Docker #########"
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

sudo modprobe overlay
sudo modprobe br_netfilter

echo "############ Copying kubernetes.conf to sysctl #############"
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

echo "############ Reload Daemon ############"
sudo sysctl --system

rm -fr /etc/containerd/config.toml
systemctl restart containerd
systemctl status containerd.service

echo "************ Slave Configuration complete ************"
echo "************ NOTE: Execute kubeadm join command from master to add this node to master **************"
