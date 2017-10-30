#!/usr/bin/env bash

export KUBECONFIG="/vagrant/config/kube/kubeconfig"
kubectl config use-context fellowship

kubefed join host-cluster --host-cluster-context=host-cluster
kubefed join fed-state1 --host-cluster-context=host-cluster
