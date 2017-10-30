#!/usr/bin/env bash

set -e

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"$ROOT/scripts/0-vagrant-up.sh"
"$ROOT/scripts/1-combine-config.sh"
"$ROOT/scripts/2-install-etcd.sh"
"$ROOT/scripts/3-install-coredns.sh"

vagrant ssh host-cluster -c "/vagrant/scripts/4-init-federation.sh"
vagrant ssh host-cluster -c "/vagrant/scripts/5-join-clusters.sh"
