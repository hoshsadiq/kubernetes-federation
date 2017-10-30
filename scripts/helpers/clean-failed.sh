#!/usr/bin/env bash

set -e

cluster="$1"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$DIR/../.." && pwd )"

export KUBECONFIG="$ROOT/config/kube/kubeconfig"

kubectl --context "$cluster" delete sa "$cluster"-host-cluster -n federation-system
kubectl --context "$cluster" delete clusterrolebinding federation-controller-manager:fellowship-"$cluster"-host-cluster
kubectl --context "$cluster" delete clusterrole federation-controller-manager:fellowship-"$cluster"-host-cluster
