.PHONY: create delete cilium jaeger prometheus istio

create:
	kind create cluster --config config.yaml

delete: 
	kind delete cluster

istio:
	helm repo add istio https://istio-release.storage.googleapis.com/charts
	helm repo update

	helm upgrade istio-base istio/base -n istio-system --set defaultRevision=default --create-namespace=true --install
	helm upgrade istiod istio/istiod -n istio-system --wait  --install
	helm upgrade istio-ingress istio/gateway -n istio-system --install
	kubectl apply -f service-mesh/istio/istio-nodeport-service.yml 
	kubectl apply -f service-mesh/istio/chip-istio.yml

jaeger:
	helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
	helm repo update
	helm upgrade jaeger jaegertracing/jaeger \
	--namespace=jaeger \
	--create-namespace=true \
	--set provisionDataStore.cassandra=false \
	--set allInOne.enabled=true \
	--set storage.type=none \
	--set agent.enabled=false \
	--set collector.enabled=false \
	--set query.enabled=false \
	--install

	# kubectl apply -f toolkit/jaeger/

nginx:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update
	helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
	--set controller.service.internal.enabled=true \
	--set controller.service.type=NodePort \
	--set controller.service.nodePorts.http=30080 \
	--set controller.service.internal.nodePorts.http=30080 \
	--set controller.publishService.enable=true \
	--install --create-namespace=true

metrics-server:
	kubectl apply -f toolkit/metric-server/

prometheus:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm upgrade prometheus prometheus-community/kube-prometheus-stack \
	--version 45.8.0 \
	--namespace=prometheus \
	--create-namespace=true \
	--install \
	-f toolkit/prometheus-stack/values.yml

	kubectl apply -f toolkit/prometheus-stack/podmonitor.yml -n prometheus


nats:
	helm repo add nats https://nats-io.github.io/k8s/helm/charts/

	helm install nats nats/nats \
	--namespace=nats \
	--create-namespace=true \
	--set nats.jetstream.enabled=true \
	--set nats.jetstream.memStorage.enabled=true \
	--set nats.jetstream.memStorage.size=1Gi \
	--set nats.jetstream.fileStorage.enabled=true \
	--set nats.jetstream.fileStorage.size=1Gi \
	--set nats.jetstream.fileStorage.storageDirectory=/data/

keda: metrics-server
	helm repo add kedacore https://kedacore.github.io/charts
	helm repo update
	helm upgrade keda kedacore/keda --namespace keda --create-namespace=true --install

cilium: jaeger
	kubectl apply -f service-mesh/cilium

	helm repo add cilium https://helm.cilium.io/;

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
	--set bgp.enabled=true \
	--set bgp.announce.loadbalancerIP=true \
	--set clustermesh.useAPIServer=true \
	--set clustermesh.apiserver.metrics.enabled=true \
	--set clustermesh.apiserver.metrics.kvstoremesh.enabled=true \
	--set clustermesh.apiserver.metrics.etcd.enabled=true \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set hubble.metrics.enableOpenMetrics=true \
	--set hubble.metrics.serviceMonitor.enabled=true \
    --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}" \
    --set prometheus.enabled=true \
	--set prometheus.serviceMonitor.enabled=true \
    --set operator.prometheus.enabled=true \
	--set operator.prometheus.serviceMonitor.enabled=true \
    --set-string extraConfig.enable-envoy-config=true \
    --set loadBalancer.l7.backend=envoy
