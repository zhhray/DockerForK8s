#!/bin/bash


#查看gcr.io镜像
#https://console.cloud.google.com/kubernetes/images/list?location=GLOBAL&project=google-containers
#通过下面的网址查看依赖镜像的版本号：
#https://kubernetes.io/docs/admin/kubeadm/
set -o errexit
set -o nounset
set -o pipefail

NODE_TYPE=${1:-"master"}

KUBE_VERSION=v1.8.4
HYPERKUBE_VERSION=v1.8.4_coreos.0
KUBE_PAUSE_VERSION=3.0
ETCD_VERSION=3.0.17
DNS_VERSION=1.14.5

GCR_URL=gcr.io/google_containers
MY_URL=zhhray

if [ "$NODE_TYPE" = 'master' ]; then
images=(
kube-proxy-amd64:${KUBE_VERSION}
kube-scheduler-amd64:${KUBE_VERSION}
kube-controller-manager-amd64:${KUBE_VERSION}
kube-apiserver-amd64:${KUBE_VERSION}
pause-amd64:${KUBE_PAUSE_VERSION}
etcd-amd64:${ETCD_VERSION}
k8s-dns-sidecar-amd64:${DNS_VERSION}
k8s-dns-kube-dns-amd64:${DNS_VERSION}
k8s-dns-dnsmasq-nanny-amd64:${DNS_VERSION}
)
fi

if [ "$NODE_TYPE" = 'slave' ]; then
images=(
kube-proxy-amd64:${KUBE_VERSION}
pause-amd64:${KUBE_PAUSE_VERSION}
)
fi

for imageName in ${images[@]} ; do
  docker pull $MY_URL/$imageName
  docker tag $MY_URL/$imageName $GCR_URL/$imageName
  docker rmi $MY_URL/$imageName
done
