.PHONY: create delete cilium jaeger prometheus

create:
	kind create cluster --config config.yaml

delete: 
	kind delete cluster

jaeger:
	helm repo add jaegertracing https://jaegertracing.github.io/helm-charts

	helm install jaeger jaegertracing/jaeger \
	--namespace=jaeger \
	--create-namespace=true \
	--set provisionDataStore.cassandra=false \
	--set allInOne.enabled=true \
	--set storage.type=none \
	--set agent.enabled=false \
	--set collector.enabled=false \
	--set query.enabled=false 

	# kubectl apply -f toolkit/jaeger/

metrics-server:
	kubectl apply -f toolkit/metric-server/

prometheus:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

	# kubectl create ns prometheus ;

	helm install prometheus prometheus-community/kube-prometheus-stack \
	--version 45.8.0 \
	--namespace=prometheus \
	--create-namespace=true \
	--set fullnameOverride=prometheus \
	--set prometheus.additionalScrapeConfigs.enabled=true \
	--set prometheus.additionalScrapeConfigs.type=external \
	--set prometheus.additionalScrapeConfigs.external.name=additional-scrape-configs \
	--set prometheus.additionalScrapeConfigs.external.key=scrape_configs.yaml \
	--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false ;

	kubectl create secret generic additional-scrape-configs --from-file=toolkit/prometheus-stack/scrape_configs.yaml --dry-run=client -oyaml > ./toolkit/prometheus-stack/additional-scrape-configs.yaml
	kubectl apply -f toolkit/prometheus-stack/additional-scrape-configs.yaml -n prometheus
	kubectl apply -f toolkit/prometheus-stack/grafana-ingress.yml

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
