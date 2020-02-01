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

ENTRY="172.31.85.10 $HOSTNAME"
echo $ENTRY >> /etc/hosts
echo "Deploying Kubernetes (with AWS)..."

export PATH=$PATH:/opt/bin
#kubeadm init --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint k8slb.sp.swarm:6443 --upload-certs
kubeadm init  --config /opt/configs/kubeadm.yaml --upload-certs
cp /opt/configs/kube-controller-manager.yaml /etc/kubernetes/manifests/kube-controller-manager.yaml

sudo -u core mkdir -p /home/core/.kube
sudo -u core sudo cp -i /etc/kubernetes/admin.conf /home/core/.kube/config
sudo -u core sudo chown core:core /home/core/.kube/config

##install Flannel CNI plugin
sudo -u core kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
mkdir -p /opt/cluster-join
kubeadm init phase upload-certs --upload-certs > /opt/cluster-join/cert
cat /opt/cluster-join/cert | sed -n '3 p' > /opt/cluster-join/cert-key
rm /opt/cluster-join/cert

kubeadm token list | grep default-node-token | cut -d' ' -f1 > /opt/cluster-join/token
openssl x509 -in /etc/kubernetes/pki/ca.crt  -noout -pubkey | openssl rsa -pubin -outform DER 2>/dev/null | sha256sum | cut -d' ' -f1 > /opt/cluster-join/cacert-hash

chown -R core:core /opt/cluster-join

#sudo -u core kubectl taint nodes --all node-role.kubernetes.io/master-
/opt/get_helm.sh
sudo -u core helm install aws-ebs-csi-driver \
    --set enableVolumeScheduling=true \
    --set enableVolumeResizing=true \
    --set enableVolumeSnapshot=true \
    https://github.com/kubernetes-sigs/aws-ebs-csi-driver/releases/download/v0.4.0/helm-chart.tgz


