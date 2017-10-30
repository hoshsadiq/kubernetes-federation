#!/usr/bin/env bash

export KUBECONFIG="/vagrant/config/kube/kubeconfig"
kubectl config use-context host-cluster

ipAddress=$(kubectl config view --minify -o json | jq --raw-output '.clusters[0].cluster.server' | grep -Po '([1-2]?[0-9]?[0-9]\.){3}[1-2]?[0-9]?[0-9]')

kubefed init fellowship \
--host-cluster-context=host-cluster \
--dns-provider=coredns \
--dns-provider-config=/vagrant/config/tmp/coredns-provider.conf \
--dns-zone-name=f8n.io \
--api-server-service-type=NodePort \
--etcd-persistent-storage=false \
--api-server-advertise-address="$ipAddress"
