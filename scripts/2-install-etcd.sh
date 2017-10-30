#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$DIR/.." && pwd )"

export KUBECONFIG="$ROOT/config/kube/kubeconfig"
kubectl config use-context host-cluster

echo "Installing requirements on host-cluster so it can host the federation"
echo "Installing helm package manager"
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller

sleep 30

echo "Installing etc-cluster inside the cluster"
helm install --namespace federation --name etcd-operator "$ROOT/helm/etcd-operator"

sleep 30

helm upgrade --namespace federation --set cluster.enabled=true etcd-operator "$ROOT/helm/etcd-operator"
