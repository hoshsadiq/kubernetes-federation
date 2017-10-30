#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$DIR/../.." && pwd )"

export KUBECONFIG="$ROOT/config/kube/kubeconfig"
kubectl config use-context host-cluster

kubectl -n federation run etcd-viewer --image nikfoundas/etcd-viewer
kubectl expose deployment -n federation etcd-viewer --port=8080 --type=NodePort
