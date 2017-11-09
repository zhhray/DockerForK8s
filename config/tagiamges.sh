#/bin/bash
images=(etcd-amd64:3.0.17 kube-apiserver-amd64:v1.8.0 kube-controller-manager-amd64:v1.8.0 kube-scheduler-amd64:v1.8.0 kube-proxy-amd64:v1.8.0 k8s-dns-kube-dns-amd64:1.14.4 k8s-dns-dnsmasq-nanny-amd64:1.14.4 k8s-dns-sidecar-amd64:1.14.4 pause-amd64:3.0 kubernetes-dashboard-init-amd64:v1.0.1 kubernetes-dashboard-amd64:v1.7.1)
for imageName in ${images[@]} ; do
  docker pull zhhray/$imageName
  docker tag zhhray/$imageName gcr.io/google_containers/$imageName
  docker rmi zhhray/$imageName
done

