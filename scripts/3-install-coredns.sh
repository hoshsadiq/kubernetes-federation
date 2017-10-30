#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$DIR/.." && pwd )"

export KUBECONFIG="$ROOT/config/kube/kubeconfig"
kubectl config use-context host-cluster

echo "Installing coredns to be use as a federation DNS server"
helm install --namespace kube-system --name coredns -f "$ROOT/config/coredns-values.yaml" "$ROOT/helm/coredns"
export NODE_PORT=$(kubectl get --namespace kube-system -o jsonpath="{.spec.ports[0].nodePort}" services coredns-coredns)
export NODE_IP=$(kubectl get nodes --namespace kube-system -o jsonpath="{.items[0].status.addresses[0].address}")
echo "$NODE_IP:$NODE_PORT"

[ ! -d "$ROOT/config/tmp" ] && mkdir -p "$ROOT/config/tmp"

cat << EOF > "$ROOT/config/tmp/coredns-provider.conf"
[Global]
etcd-endpoints = http://etcd-cluster.federation:2379
zones = f8n.io.
coredns-endpoints = $NODE_IP:$NODE_PORT
EOF
