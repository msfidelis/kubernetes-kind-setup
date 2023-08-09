# Creating a custom cluster 

```bash
kind create cluster --config config.yaml
```

# Deploy Metric Server 

```bash
kubectl apply -f toolkit/metric-server/metric-server.yml
```

# Deploy Keda Autoscaler

```bash
kubectl apply -f toolkit/keda/keda-2.2.0.yaml
```

# Deploy Cilium 

```bash
helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.14 \
--namespace kube-system \
--set kubeProxyReplacement=strict \
--set externalIPs.enabled=true \
--set nodePort.enabled=true \
--set hostPort.enabled=true \
--set hostServices.enabled=true \
--set ingressController.enabled=true \
--set ingressController.service.type=NodePort \
--set ingressController.service.insecureNodePort=30080 \
--set ingressController.service.secureNodePort=30443 \
--set ingressController.loadbalancerMode=shared \
--set prometheus.enabled=true \
--set operator.prometheus.enabled=true \
--set hubble.relay.enabled=true \
--set hubble.ui.enabled=true \
--set hubble.metrics.enableOpenMetrics=true \
--set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\\,source_namespace\\,source_workload\\,destination_ip\\,destination_namespace\\,destination_workload\\,traffic_direction}" \
--set loadBalancer.l7.backend=envoy \
--set-string extraConfig.enable-envoy-config=true
```

# Deploy Ingress Controller

### Nginx

```bash
kubectl apply -f ingress/nginx/ingress.yml
```

### Nginx in Daemonset Mode

```bash
kubectl apply -f ingress/nginx/ingress-daemonset.yml
```


### Traefik

```bash
kubectl apply -f ingress/traefik/ingress.yml
```

### Kong 

```bash
kubectl apply -f ingress/kong/ingress.yml
```



# Deploy demo application for tests 

```bash
kubectl apply -f toolkit/demo-apps/whois/whois.yml
kubectl apply -f toolkit/demo-apps/chip/chip.yml
```

```bash
curl 0.0.0.0:80/whois/google.com -H "Host: whois.local.cluster" -i
HTTP/1.1 200 OK
Date: Wed, 24 Mar 2021 20:18:41 GMT
Content-Type: application/json
Content-Length: 1706
Connection: keep-alive

{"domainName":"google.com","registryDomainId":"2138514_DOMAIN_COM-VRSN","registrarWhoisServer":"whois.markmonitor.com","registrarUrl":"http://www.markmonitor.com"}
```


```bash
curl 0.0.0.0:80/system -H "Host: chip.local.cluster" -i
HTTP/1.1 200 OK
Date: Wed, 24 Mar 2021 20:24:09 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 102
Connection: keep-alive

{"hostname":"chip-b65c4c85f-jpj98","cpus":2,"os":"Alpine Linux v3.12","hypervisor":"bhyve","memory":0}
```
