# Installation

```bash
helm repo add cilium https://helm.cilium.io/
```

```bash
helm install cilium cilium/cilium --version 1.13.2 \
    --namespace kube-system \
    --set kubeProxyReplacement=strict \
    --set ingressController.enabled=true \
    --set ingressController.loadbalancerMode=shared \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \    
    --set-string extraConfig.enable-envoy-config=true \
    --set loadBalancer.l7.backend=envoy
```

```bash
helm upgrade cilium cilium/cilium --version 1.13.2 \
    --namespace kube-system \
    --reuse-values \
    --set kubeProxyReplacement=strict \
    --set ingressController.enabled=true \
    --set ingressController.service.type=NodePort \
    --set ingressController.service.insecureNodePort=30080 \
    --set ingressController.service.secureNodePort=30443 \
    --set ingressController.loadbalancerMode=shared \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set loadBalancer.l7.backend=envoy \
    --set-string extraConfig.enable-envoy-config=true 
```

```bash
kubectl -n kube-system rollout restart deployment/cilium-operator
kubectl -n kube-system rollout restart ds/cilium
```