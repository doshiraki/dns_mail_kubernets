#!/bin/bash
myhost=127.0.0.1
k3d cluster create mycluster --agents 1 \
    -v $(pwd)/pv/server:/mnt/pv@server:0 \
    -v $(pwd)/pv/agent:/mnt/pv@agent:0 \
    --registry-create mycluster-registry:0.0.0.0:5000 \
    --k3s-node-label is_worker=true@agent:0 \
    --no-lb
rm -r ~/.kube
mkdir ~/.kube
k3d kubeconfig get mycluster > ~/.kube/config
kubectl delete -f kubeset/sc 
kubectl create -f kubeset/sc 
kubectl create namespace myns
kubectl config set-context --current --namespace myns
kubectl apply -f kubeset/configmaps
kubectl create -f kubeset/pvc
#kubectl create -f kubeset/ansible.yml
