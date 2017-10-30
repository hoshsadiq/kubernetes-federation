#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$DIR/../.." && pwd )"

export KUBECONFIG="$ROOT/config/kube/kubeconfig"
kubectl config use-context host-cluster

kubectl delete ns federation-system
$DIR/clean-failed.sh fed-state1
$DIR/clean-failed.sh host-cluster
