#!/bin/sh

set -ex

apiserverAdvertiseAddress="$1"
podNetworkCidr="$2"
zone="$3"
region="$4"
hostName="$(hostname)"

# Source: http://kubernetes.io/docs/getting-started-guides/kubeadm/

curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y docker.io kubelet kubeadm kubectl kubernetes-cni jq

curl -sSLO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/kubernetes-client-linux-amd64.tar.gz
tar -xzvf kubernetes-client-linux-amd64.tar.gz
sudo cp kubernetes/client/bin/kubefed /usr/local/bin
sudo chmod +x /usr/local/bin/kubefed

sudo kubeadm init --pod-network-cidr="$podNetworkCidr" --apiserver-advertise-address="$apiserverAdvertiseAddress"
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/rbac.yaml
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/canal.yaml
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf taint nodes --all node-role.kubernetes.io/master-
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf label node "$hostName" failure-domain.beta.kubernetes.io/zone="$zone"
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf label node "$hostName" failure-domain.beta.kubernetes.io/region="$region"

sudo kubectl --kubeconfig /etc/kubernetes/admin.conf config view --flatten -o json | sed -e "s/kubernetes/$hostName/g" -e "s/-admin@$hostName//g" > "/vagrant/config/kube/$hostName.conf"

