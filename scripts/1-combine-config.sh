#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$DIR/.." && pwd )"

export KUBECONFIG="$(printf '%s:' ${ROOT}/config/kube/*.conf | sed 's/:$//')"
kubectl config view --flatten -o json > "$ROOT/config/kube/kubeconfig"

export KUBECONFIG="$ROOT/config/kube/kubeconfig"
kubectl config use-context host-cluster
