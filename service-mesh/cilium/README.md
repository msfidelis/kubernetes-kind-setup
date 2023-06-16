# Installation

```bash
helm repo add cilium https://helm.cilium.io/
```

```bash
helm install cilium cilium/cilium --version 1.13.2 \
    --namespace kube-system \
    --set kubeProxyReplacement=strict \
    --set hostServices.enabled=false \
    --set externalIPs.enabled=true \
    --set nodePort.enabled=true \
    --set hostPort.enabled=true \
    --set ipam.mode=kubernetes \
    --set ingressController.enabled=true \
    --set ingressController.service.type=NodePort \
    --set ingressController.service.insecureNodePort=30080 \
    --set ingressController.service.secureNodePort=30443 \
    --set ingressController.loadbalancerMode=shared \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set hubble.metrics.enableOpenMetrics=true \
    --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}" \
    --set prometheus.enabled=true \
    --set operator.prometheus.enabled=true \
    --set-string extraConfig.enable-envoy-config=true \
    --set loadBalancer.l7.backend=envoy
```

```bash
helm upgrade cilium cilium/cilium --version 1.13.2 \
    --namespace kube-system \
    --reuse-values \
    --set kubeProxyReplacement=strict \
    --set hostServices.enabled=false \
    --set externalIPs.enabled=true \
    --set nodePort.enabled=true \
    --set hostPort.enabled=true \
    --set ipam.mode=kubernetes \
    --set ingressController.enabled=true \
    --set ingressController.service.type=NodePort \
    --set ingressController.service.insecureNodePort=30080 \
    --set ingressController.service.secureNodePort=30443 \
    --set ingressController.loadbalancerMode=shared \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set hubble.metrics.enableOpenMetrics=true \
    --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}" \
    --set prometheus.enabled=true \
    --set operator.prometheus.enabled=true \
    --set-string extraConfig.enable-envoy-config=true \
    --set loadBalancer.l7.backend=envoy
```

```bash
kubectl -n kube-system rollout restart deployment/cilium-operator
kubectl -n kube-system rollout restart ds/cilium
```