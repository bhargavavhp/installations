echo "############ Installing pre-requisites ############"
echo
sudo apt update
sudo apt -y install curl apt-transport-https
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo
echo "############ Installing k8s components ############"
echo
sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo
echo "############ Installed kubectl version ############"
echo
kubectl version --client && kubeadm version

echo
echo "############ Setting swap off ###########"
echo
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

echo
echo "############ Copying Kubernetes.conf ############"
echo
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

echo
echo "############ Reload Daemon ############"
echo
sudo sysctl --system

echo
echo "############ Installing containerd and Docker ############"
echo
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io docker-ce docker-ce-cli

sudo mkdir -p /etc/systemd/system/docker.service.d

echo
echo "############ Copying Docker Daemon json file ##########"
echo
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

echo
echo "############ Reload Daemon and enable Docker #########"
echo
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

sudo modprobe overlay
sudo modprobe br_netfilter

echo
echo "############ Copying kubernetes.conf to sysctl #############"
echo
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

echo
echo "############ Reload Daemon ############"
echo
sudo sysctl --system

echo
echo "############ Configuring Kubernetes Master Node ############"
echo
lsmod | grep br_netfilter

echo
echo "############ Enable kubelet ##########"
echo
sudo systemctl enable kubelet

rm -fr /etc/containerd/config.toml
systemctl restart containerd
systemctl status containerd.service

echo
echo
echo "############ Initializing Kubernetes Cluster ##########"
echo
kubeadm init

echo
echo "############ Copying kube config to home directory ##########"
echo
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo
echo "############ Creating networking solution for k8s cluster ############"
echo
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo
echo
echo "************** Kubernetes Master Node is Initialized ***************"
echo "************** NOTE: Please execute kubeadm join command on Worker node ***************"
echo
