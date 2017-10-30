# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install a kube cluster using kubeadm:
# http://kubernetes.io/docs/getting-started-guides/kubeadm/

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_check_update = false

  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = "2048"
  end

  config.vm.define "host-cluster" do |c|
      c.vm.hostname = "host-cluster"
      c.vm.network "private_network", ip: "192.168.77.10"
      c.vm.provision "shell" do |s|
        s.path = "scripts/provisioning/provision-cluster.sh"
        s.args = ["192.168.77.10", "10.244.0.0/16", "zone1", "a"]
      end
  end

  config.vm.define "fed-state1" do |c|
      c.vm.hostname = "fed-state1"
      c.vm.network "private_network", ip: "192.168.77.11"
      c.vm.provision "shell" do |s|
        s.path = "scripts/provisioning/provision-cluster.sh"
        s.args = ["192.168.77.11", "10.245.0.0/16", "zone2", "a"]
      end
  end

end
