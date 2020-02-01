#!/bin/bash

set -o xtrace
systemctl enable docker
systemctl start docker

##Install CNI plugins (required for most pod network)
CNI_VERSION="v0.8.2"
mkdir -p /opt/cni/bin
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz" | tar -C /opt/cni/bin -xz
##Install crictl (required for kubeadm / Kubelet Container Runtime Interface (CRI))
CRICTL_VERSION="v1.16.0"
mkdir -p /opt/bin
curl -L "https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz" | tar -C /opt/bin -xz
##Install kubeadm, kubelet, kubectl and add a kubelet systemd service
RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"

mkdir -p /opt/bin
cd /opt/bin
curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/{kubeadm,kubelet,kubectl}
chmod +x {kubeadm,kubelet,kubectl}

curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/kubelet.service" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service
mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/10-kubeadm.conf" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
##Enable and start kubelet
systemctl enable --now kubelet
echo "Deploying Kubernetes (with AWS)..."
export PATH=$PATH:/opt/bin

ENTRY="172.31.85.40 $HOSTNAME"
echo $ENTRY >> /etc/hosts

mkdir -p /opt/cluster-join
while true
    do
	    echo "Waiting for first Cluster master to be initialized..."
		sleep 20
        scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -i /home/core/.ssh/coreos-key core@172.31.85.10:/opt/cluster-join/token /opt/cluster-join/
        scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -i /home/core/.ssh/coreos-key core@172.31.85.10:/opt/cluster-join/cacert-hash /opt/cluster-join/

        FILE=/opt/cluster-join/token
        if test -f "$FILE"; then
            echo "$FILE exist"
            break
        fi

	done

#kubeadm join k8slb.sp.swarm:6443 --token $(cat /opt/cluster-join/token) --discovery-token-ca-cert-hash sha256:$(cat /opt/cluster-join/cacert-hash)
export TOKEN=$(cat /opt/cluster-join/token)
export CACERT_HASH=sha256:$(cat /opt/cluster-join/cacert-hash)
envsubst < /opt/configs/kubeadm-tmpl.yaml > /opt/configs/kubeadm.yaml
kubeadm join --config /opt/configs/kubeadm.yaml
